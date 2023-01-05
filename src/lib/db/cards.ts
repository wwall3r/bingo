import type { TypedSupabaseClient } from './utils';
import wrap from './wrap';

const table = 'cards';

// TODO: The goal is to remove this and have the query entirely typed
// properly by the query itself. However, that's still got an issue
// where it types joins as T || T[] instead of properly detecting whether
// a relationship is 1-1 or 1-n.
//
// Until that time, we will override the detected type.
//
// See https://github.com/supabase/postgrest-js/issues/303 for more
type ForceNestedJoin = {
	id: string;
	user_profiles: { id: string; display_name: string };
	completions: {
		id: string;
		notes?: string;
		state: number;
		objectives: {
			id: string;
			label: string;
			description?: string;
		};
	}[];
};

const allForGame = (client: TypedSupabaseClient, gameId: string) =>
	wrap(
		client
			.from(table)
			.select(
				`
			id,
			user_profiles (
				id,
				display_name
			),
			completions (
				id,
				notes,
				state,
				objectives (
					id,
					label,
					description
				)
			),
			games_cards!inner(game_id)
		`
			)
			.eq('games_cards.game_id', gameId)
			.returns<ForceNestedJoin>()
	);

const one = (client: TypedSupabaseClient, cardId: string) =>
	wrap(
		client
			.from(table)
			.select(
				`
				id,
				user_profiles (
					id,
					display_name
				),
				completions (
					id,
					notes,
					state,
					objectives (
						id,
						label,
						description
					)
				)
			`
			)
			.eq('id', cardId)
			.returns<ForceNestedJoin>()
			.single()
	);

export default {
	async allForGame(client: TypedSupabaseClient, gameId: string) {
		const tiles = await allForGame(client, gameId);
		return tiles?.map(addFreeSpace);
	},

	async one(client: TypedSupabaseClient, cardId: string) {
		return addFreeSpace(await one(client, cardId));
	},

	async gameFor(client: TypedSupabaseClient, cardId: string) {
		return wrap(
			client
				.from('games')
				.select(
					`
					*,
					games_cards!inner(game_id)
				`
				)
				.eq('games_cards.card_id', cardId)
				.single()
		);
	},

	async create(client: TypedSupabaseClient, gameId: string, numObjectives = 24) {
		return wrap(
			// see https://github.com/supabase/cli/issues/752
			// eslint-disable-next-line
			// @ts-ignore
			client.rpc('create_card', {
				p_game_id: gameId,
				p_num_objectives: numObjectives
			})
		);
	}
};

export type GameCard = Awaited<ReturnType<typeof one>>;

type Unarray<T> = T extends Array<infer U> ? U : T;
export type Completion = Unarray<Exclude<GameCard, null>['completions']>;

const addFreeSpace = (card: GameCard): GameCard => {
	// TODO: this should really be computed by either game size
	// or number of card tiles, and should only be done for odd game sizes
	// (e.g. 4^2 doesn't get a free space, but 5^2 does)
	const completions = card?.completions;

	if (Array.isArray(completions)) {
		completions.splice(12, 0, {
			id: 'free-space',
			notes: "Don't you like free stuff?",
			state: 2,
			objectives: {
				id: '-1',
				description: 'Free as in beer',
				label: 'Free Space'
			}
		});
	}

	return card;
};
