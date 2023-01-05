import { withAuthenticatedSupabase } from '$lib/db/utils';
import Cards from '$lib/db/cards';
import type { Actions } from './$types';

export const actions = {
	createCard: async (event) =>
		withAuthenticatedSupabase(event, async (supabaseClient) => {
			await Cards.create(supabaseClient, event.params.gameId);
			return { success: true };
		})
} satisfies Actions;
