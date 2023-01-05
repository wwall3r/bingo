import type { PageLoad } from './$types';
import Cards from '$lib/db/cards';
import { withAuthenticatedSupabase } from '$lib/db/utils';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		game: await Cards.gameFor(supabaseClient, event.params.cardId),
		card: await Cards.one(supabaseClient, event.params.cardId)
	}))) satisfies PageLoad;
