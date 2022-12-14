import type { TypedSupabaseClient } from './utils';
import wrap from './wrap';

const table = 'games';

export default {
	async all(client: TypedSupabaseClient) {
		return wrap(client.from(table).select());
	},

	async one(client: TypedSupabaseClient, gameId: string) {
		return wrap(client.from(table).select().eq('id', gameId).single());
	},

	async members(client: TypedSupabaseClient, gameId: string) {
		return wrap(
			client
				.from('user_profiles')
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
