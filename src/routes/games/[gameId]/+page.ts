import { withAuthenticatedSupabase } from '$lib/db/utils';
import Cards, { getWinningCompletions } from '$lib/db/cards';
import Games from '$lib/db/games';
import type { PageLoad } from './$types';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => {
		const cards = await Cards.allForGame(supabaseClient, event.params.gameId);

		const wins: Set<string> = new Set();

		return {
			game: await Games.one(supabaseClient, event.params.gameId),
			cards,
			wins: cards?.reduce((set, card) => getWinningCompletions(card, set), wins) ?? wins
		};
	})) satisfies PageLoad;
