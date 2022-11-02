import type { TypedSupabaseClient } from '@supabase/auth-helpers-sveltekit';
import wrap from './wrap';
import type { definitions } from './types';

const table = 'boards';

export type Board = definitions['boards'];
export type Completion = definitions['completions'];

type GameProfile = {
	display_name: definitions['user_profiles']['display_name'];
};

type GameObjective = {
	id: definitions['objectives']['id'];
	label: definitions['objectives']['label'];
	description: definitions['objectives']['description'];
};

type GameCompletions = {
	id: Completion['id'];
	notes: Completion['notes'];
	state: Completion['state'];
	objectives: GameObjective;
};

export type GameBoard = {
	id: Board['id'];
	user_profiles: GameProfile;
	completions: GameCompletions[];
};

export default {
	async allForGame(client: TypedSupabaseClient, gameId: string): Promise<GameBoard[]> {
		const tiles = await wrap(() =>
			client
				.from<GameBoard>(table)
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
		);

		return tiles?.map(addFreeSpace);
	},

	async one(client: TypedSupabaseClient, boardId: string): Promise<GameBoard> {
		return addFreeSpace(
			await wrap(() =>
				client
					.from<GameBoard>(table)
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
					.single()
			)
		);
	},

	async create(client: TypedSupabaseClient, gameId: string, numObjectives = 24): Promise<void> {
		return wrap(
			client.rpc('create_board', {
				p_game_id: gameId,
				p_num_objectives: numObjectives
			})
		);
	}
};

const addFreeSpace = (board: Board): Board => {
	// TODO: this should really be computed by either game size
	// or number of board tiles, and should only be done for odd game sizes
	// (e.g. 4^2 doesn't get a free space, but 5^2 does)
	board?.completions.splice(12, 0, {
		state: 2,
		objectives: {
			label: 'Free Space'
		}
	});

	return board;
};
