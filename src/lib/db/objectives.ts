import supabase from '../db';

const table = 'objectives';

export default {
	async all() {
		const { data, error } = await supabase.from(table).select();
		if (error) throw new Error(error.message);
		return data;
	},

	async insert(objectives) {
		const { data, error } = await supabase
			.from(table)
			.insert(Array.isArray(objectives) ? objectives : [objectives]);
		if (error) throw new Error(error.message);
		return data;
	}
};

