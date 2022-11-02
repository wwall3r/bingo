import type { Actions, PageLoad } from './$types';
import { withAuthenticatedSupabase } from '$lib/db/utils';
import Boards from '$lib/db/boards';
import Games from '$lib/db/games';

export const load: PageLoad = async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		game: await Games.one(supabaseClient, event.params.gameId),
		boards: await Boards.allForGame(supabaseClient, event.params.gameId)
	}));

export const actions: Actions = {
	createBoard: async (event) =>
		withAuthenticatedSupabase(event, async (supabaseClient) => {
			await Boards.create(supabaseClient, event.params.gameId);
			return { success: true };
		})
};
