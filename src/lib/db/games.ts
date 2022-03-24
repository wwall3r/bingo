import supabase from '../db';
import wrap from './wrap';
import type { definitions } from './types';
import type { UserProfile } from './user_profiles';

const table = 'games';

export type Game = definitions['games'];

export default {
	async all(): Promise<Game[]> {
		return wrap(() => supabase.from<Game>(table).select());
	},

	async one(gameId: string): Promise<Game> {
		return wrap(() => supabase.from<Game>(table).select().eq('id', gameId).single());
	},

	async members(gameId: string): Promise<UserProfile[]> {
		return wrap(() =>
			supabase
				.from<UserProfile & definitions['games_users']>('user_profiles')
				.select(
					`
					id,
					display_name,
					games_users!inner(game_id)
				`
				)
				.eq('games_users.game_id', gameId)
		);
	}
};
