import type { PageLoad } from './$types';
import Boards from '$lib/db/boards';
import { withAuthenticatedSupabase } from '$lib/db/utils';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		game: await Boards.gameFor(supabaseClient, event.params.boardId),
		board: await Boards.one(supabaseClient, event.params.boardId)
	}))) satisfies PageLoad;
