import type { PageLoad } from './$types';
import Boards from '$lib/db/boards';
import { withAuthenticatedSupabase } from '$lib/db/utils';

export const load: PageLoad = async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		board: await Boards.one(supabaseClient, event.params.boardId)
	}));
