import type { TypedSupabaseClient } from '@supabase/auth-helpers-sveltekit';
import type { RequestEvent } from '@sveltejs/kit';
import { getSupabase } from '@supabase/auth-helpers-sveltekit';
import { redirectToLogin } from '$lib/auth/redirects';

export const withAuthenticatedSupabase = async (
	event: RequestEvent,
	cmd: (client: TypedSupabaseClient) => Promise<T>
) => {
	const { session, supabaseClient } = await getSupabase(event);

	if (!session) {
		throw redirectToLogin(event);
	}

	try {
		return cmd(supabaseClient);
	} catch (error) {
		// log the error on the server or in the console depending on context
		console.error(error);
	}

	// display friendlier error to the user
	error(500, 'We could not load the page data');
};
