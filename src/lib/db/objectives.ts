import supabase from '../db';
import wrap from './wrap';

const table = 'objectives';

export default {
	async all() {
		return wrap(await supabase.from(table).select());
	},

	async insert(objectives) {
		return wrap(
			await supabase.from(table).insert(Array.isArray(objectives) ? objectives : [objectives])
		);
	}
};
