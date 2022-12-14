import { getSupabase } from '@supabase/auth-helpers-sveltekit';
import { redirectToPage } from '$lib/auth/redirects';
import type { Actions } from './$types';

export const actions = {
	async default(event) {
		const { supabaseClient } = await getSupabase(event);
		await supabaseClient.auth.signOut();
		throw await redirectToPage(event);
	}
} satisfies Actions;
