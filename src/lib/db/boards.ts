import type { TypedSupabaseClient } from './utils';
import wrap from './wrap';

const table = 'boards';

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
	user_profiles: { display_name: string };
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
			games_boards!inner(game_id)
		`
			)
			.eq('games_boards.game_id', gameId)
			.returns<ForceNestedJoin>()
	);

const one = (client: TypedSupabaseClient, boardId: string) =>
	wrap(
		client
			.from(table)
			.select(
				`
				id,
				user_profiles (
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
			.eq('id', boardId)
			.returns<ForceNestedJoin>()
			.single()
	);

export default {
	async allForGame(client: TypedSupabaseClient, gameId: string) {
		const tiles = await allForGame(client, gameId);
		return tiles?.map(addFreeSpace);
	},

	async one(client: TypedSupabaseClient, boardId: string) {
		return addFreeSpace(await one(client, boardId));
	},

	async create(client: TypedSupabaseClient, gameId: string, numObjectives = 24) {
		return wrap(
			// see https://github.com/supabase/cli/issues/752
			// @ts-ignore
			client.rpc('create_board', {
				p_game_id: gameId,
				p_num_objectives: numObjectives
			})
		);
	}
};

export type GameBoard = Awaited<ReturnType<typeof one>>;

type Unarray<T> = T extends Array<infer U> ? U : T;
export type Completion = Unarray<Exclude<GameBoard, null>['completions']>;

const addFreeSpace = (board: GameBoard): GameBoard => {
	// TODO: this should really be computed by either game size
	// or number of board tiles, and should only be done for odd game sizes
	// (e.g. 4^2 doesn't get a free space, but 5^2 does)
	const completions = board?.completions;

	if (Array.isArray(completions)) {
		completions.splice(12, 0, {
			id: '-1',
			notes: "Don't you like free stuff?",
			state: 2,
			objectives: {
				id: '-1',
				description: 'Free as in beer',
				label: 'Free Space'
			}
		});
	}

	return board;
};
