import supabase from '../db';
import wrap from './wrap';
import type { definitions } from './types';

const table = 'boards';

type Boards = definitions['boards'];
type Completions = definitions['completions'];

export default {
	async one(boardId: string): Promise<Board> {
		return wrap(
			await supabase
				.from<Board[]>(table)
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
						objective (
							id,
							label,
							description
						)
					)
				`
				)
				.eq('id', boardId)
				.single()
		);
	}
};
