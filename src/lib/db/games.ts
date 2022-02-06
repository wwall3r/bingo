import supabase from '../db';
import wrap from './wrap';

const table = 'games';

export default {
	async all() {
		return wrap(await supabase.from(table).select());
	},

	async one(gameId: string) {
		return wrap(await supabase.from(table).select().eq('id', gameId));
	},

	async members(gameId: string) {
		return wrap(
			await supabase
				.from('games_users')
				.select(
					`
					user_profiles {
						user_id,
						display_name
					}
				`
				)
				.eq('game_id', gameId)
		);
	}
};
