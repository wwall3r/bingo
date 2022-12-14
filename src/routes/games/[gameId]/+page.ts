import { withAuthenticatedSupabase } from '$lib/db/utils';
import Boards from '$lib/db/boards';
import Games from '$lib/db/games';
import type { PageLoad } from './$types';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		game: await Games.one(supabaseClient, event.params.gameId),
		boards: await Boards.allForGame(supabaseClient, event.params.gameId)
	}))) satisfies PageLoad;
