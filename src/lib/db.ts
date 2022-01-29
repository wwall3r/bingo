import { createClient } from '@supabase/supabase-js';
import { readable } from 'svelte/store';

export const supabase = createClient(
	import.meta.env.VITE_SUPABASE_URL as string,
	import.meta.env.VITE_SUPABASE_ANON_KEY as string
);

export const { auth } = supabase;

export const user = readable(auth.user(), (set) => {
	auth.onAuthStateChange((event) => {
		if (event == 'SIGNED_OUT') {
			set(null);
		}
	});
});

// TODO: it'd be useful to generate types/interfaces from tables
export const games = {
	async all() {
		const { data, error } = await supabase.from('games').select();
		if (error) throw new Error(error.message);
		return data;
	},
	async insert(game) {
		const { data, error } = await supabase.from('games').insert([game]);
		if (error) throw new Error(error.message);
		return data;
	}
};
