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
			.order('id', { foreignTable: 'completions', ascending: false })
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
			.order('id', { foreignTable: 'completions', ascending: false })
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

const getCardSize = (card: GameCard): number => {
	const completions = card?.completions;
	let size = 0;

	if (Array.isArray(completions)) {
		size = Math.sqrt(completions.length);

		// in case the free space hasn't been inserted yet
		if (!Number.isInteger(size)) {
			size = Math.sqrt(completions.length + 1);
		}
	}

	return size;
};

const addFreeSpace = (card: GameCard): GameCard => {
	const size = getCardSize(card);

	if (size % 2 === 1) {
		card?.completions.splice(card?.completions.length / 2, 0, {
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

/**
 * Cards have won if any row, column, or diagonal is fully complete
 */
export const getWinningCompletions = (
	card: GameCard,
	set: Set<string> = new Set()
): Set<string> => {
	const size = getCardSize(card);
	const lines = computeLines(card, size);

	// now see if any lines have a length equal to the card size
	return Object.entries(lines).reduce((ids, [, line]) => {
		if (line.length === size) {
			line.forEach(ids.add, ids);
		}

		return ids;
	}, set);
};

const computeLines = (card: GameCard, size: number = -1): Record<string, string[]> => {
	if (size < 0) {
		size = getCardSize(card);
	}

	const completions = card?.completions;

	// iterate all spaces and compute the length of each possible line
	const lines: Record<string, string[]> = {};

	if (!validateCard(card, size)) {
		return lines;
	}

	if (completions) {
		for (let x = 0; x < size; x++) {
			for (let y = 0; y < size; y++) {
				const completion = completions[y * size + x];

				if (completion.state === 2) {
					// columns
					addCompletionToLines(lines, 'x' + x, completion.id);

					// rows
					addCompletionToLines(lines, 'y' + y, completion.id);

					// first diagonal
					if (x === y) {
						addCompletionToLines(lines, 'd1', completion.id);
					}

					// second diagonal
					if (x === size - y - 1) {
						addCompletionToLines(lines, 'd2', completion.id);
					}
				}
			}
		}
	}

	return lines;
};

const validateCard = (card: GameCard, size: number): boolean => {
	const completions = card?.completions;
	let error = false;

	if (!Array.isArray(completions)) {
		console.warn('card is non-existant or contains no completions', card);
		error = true;
	}

	if (!size) {
		console.warn('card size is zero', card);
		error = true;
	}

	if (completions?.length !== size * size) {
		console.warn('card is not square', card);
		error = true;
	}

	return !error;
};

const addCompletionToLines = (lines: Record<string, string[]>, line: string, id: string) => {
	lines[line] ??= [];
	lines[line].push(id);
};
