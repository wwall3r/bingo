import { withAuthenticatedSupabase } from '$lib/db/utils';
import Cards from '$lib/db/cards';
import Games from '$lib/db/games';
import type { PageLoad } from './$types';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		game: await Games.one(supabaseClient, event.params.gameId),
		cards: await Cards.allForGame(supabaseClient, event.params.gameId)
	}))) satisfies PageLoad;
