import { withAuthenticatedSupabase } from '$lib/db/utils';
import Boards from '$lib/db/boards';
import type { Actions } from './$types';

export const actions = {
	createBoard: async (event) =>
		withAuthenticatedSupabase(event, async (supabaseClient) => {
			await Boards.create(supabaseClient, event.params.gameId);
			return { success: true };
		})
} satisfies Actions;
