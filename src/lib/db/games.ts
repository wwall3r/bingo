import supabase from '../db';
import wrap from './wrap';

const table = 'games';
const members = 'games_users';

export default {
	async all() {
		return wrap(await supabase.from(table).select());
	},

	async members(gameId: string) {
		return wrap(
			await supabase
				.from(games)
				.select(
					`*,
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
