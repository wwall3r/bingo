import type { PageLoad } from './$types';
import { withAuthenticatedSupabase } from '$lib/db/utils';
import Games from '$lib/db/games';

export const load: PageLoad = async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		games: await Games.all(supabaseClient)
	}));
