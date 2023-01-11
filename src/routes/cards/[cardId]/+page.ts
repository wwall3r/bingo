import type { PageLoad } from './$types';
import Cards, { getWinningCompletions } from '$lib/db/cards';
import { withAuthenticatedSupabase } from '$lib/db/utils';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => {
		const card = await Cards.one(supabaseClient, event.params.cardId);

		return {
			game: await Cards.gameFor(supabaseClient, event.params.cardId),
			card,
			wins: getWinningCompletions(card)
		};
	})) satisfies PageLoad;
