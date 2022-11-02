import type { PageLoad } from './$types';
import { getSupabase } from '@supabase/auth-helpers-sveltekit';
import { error, redirect } from '@sveltejs/kit';
import Objectives from '$lib/db/objectives';

export const load: PageLoad = async (event) => {
	const { session, supabaseClient } = await getSupabase(event);

	try {
		return await Objectives.all(supabaseClient);
	} catch (e) {
		console.error(e);
	}

	throw error(404, 'objectives not found');
};
