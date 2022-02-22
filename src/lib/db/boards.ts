import supabase from '../db';
import wrap from './wrap';
import type { definitions } from './types';

const table = 'boards';

export type Board = definitions['boards'];
export type Completion = definitions['completions'];

export default {
	async allForGame(gameId: string): Promise<Board[]> {
		return wrap(
			await supabase
				.from<Board[]>(table)
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
		).map(addFreeSpace);
	},

	async one(boardId: string): Promise<Board> {
		return addFreeSpace(
			wrap(
				await supabase
					.from<Board[]>(table)
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
	}
};

const addFreeSpace = (board: Board): Board => {
	// TODO: this should really be computed by either game size
	// or number of board tiles, and should only be done for odd game sizes
	// (e.g. 4^2 doesn't get a free space, but 5^2 does)
	board.completions.splice(12, 0, {
		state: 2,
		objectives: {
			label: 'Free Space'
		}
	});

	return board;
};
