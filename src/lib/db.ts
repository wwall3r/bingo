import { parse as cookieParse } from 'cookie-es';
import { createClient } from '@supabase/supabase-js';
import '$lib/cookie-change';
import { browser } from '$app/env';

export const supabase = createClient(
	import.meta.env.VITE_SUPABASE_URL as string,
	import.meta.env.VITE_SUPABASE_ANON_KEY as string
);

export const { auth } = supabase;

if (browser) {
	const update = () => {
		const cookies: Record<string, string> = cookieParse(document.cookie);
		if (cookies.access_token) {
			auth.setAuth(cookies.access_token);
		}
	};

	document.addEventListener('cookiechange', update);
	update();
}

// TODO: it'd be useful to generate types/interfaces from tables
export const objectives = {
	async all() {
		const { data, error } = await supabase.from('objectives').select();
		if (error) throw new Error(error.message);
		return data;
	},
	async insert(objective) {
		const { data, error } = await supabase
			.from('objectives')
			.insert(Array.isArray(objective) ? objective : [objective]);
		if (error) throw new Error(error.message);
		return data;
	}
};
