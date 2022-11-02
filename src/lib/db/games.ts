import type { TypedSupabaseClient } from '@supabase/auth-helpers-sveltekit';
import type { definitions } from './types';
import type { UserProfile } from './user_profiles';
import wrap from './wrap';

const table = 'games';

export type Game = definitions['games'];

export default {
	async all(client: TypedSupabaseClient): Promise<Game[]> {
		return wrap(client.from<Game>(table).select());
	},

	async one(client: TypedSupabaseClient, gameId: string): Promise<Game> {
		return wrap(client.from<Game>(table).select().eq('id', gameId).single());
	},

	async members(client: TypedSupabaseClient, gameId: string): Promise<UserProfile[]> {
		return wrap(
			client
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
