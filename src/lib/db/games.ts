import supabase from '../db';
import wrap from './wrap';
import type { definitions } from './types';
import type { UserProfile } from './user_profiles';

const table = 'games';

export type Game = definitions['games'];

export default {
	async all(): Promise<Game[]> {
		return wrap(await supabase.from(table).select());
	},

	async one(gameId: string): Promise<Game> {
		return wrap(await supabase.from(table).select().eq('id', gameId));
	},

	async members(gameId: string): Promise<UserProfile> {
		return wrap(
			await supabase
				.from('games_users')
				.select(
					`
					user_profiles {
						profile_id,
						display_name
					}
				`
				)
				.eq('game_id', gameId)
		);
	}
};
