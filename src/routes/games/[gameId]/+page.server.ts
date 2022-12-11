import { withAuthenticatedSupabase } from '$lib/db/utils';
import Boards from '$lib/db/boards';
import type { Actions } from './$types';

export const actions: Actions = {
	createBoard: async (event) => {
		console.log('running createBoard action');
		return withAuthenticatedSupabase(event, async (supabaseClient) => {
			console.log('creating board');
			const board = await Boards.create(supabaseClient, event.params.gameId);

			console.log('returning success');
			return { success: true };
		});
	}
};
