import { error } from '@sveltejs/kit';
import Boards from '$lib/db/boards';
import Games from '$lib/db/games';
import supabase from '$lib/db';
import { redirectToLogin } from '$lib/auth/helper';

/** @type {import('./$types').PageLoad} */
export async function load({ params, session, url }) {
	if (!session?.user) {
		return redirectToLogin(url);
	}

	try {
		const game = await Games.one(params.gameId);
		const boards = await Boards.allForGame(params.gameId);
		return { game, boards };
	} catch (error) {}

	error(404, 'game boards not found');
}
