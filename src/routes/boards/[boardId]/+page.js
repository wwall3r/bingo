import { error } from '@sveltejs/kit';
import Boards from '$lib/db/boards';
import { redirectToLogin } from '$lib/auth/helper';

/** @type {import('./$types').PageLoad} */
export async function load({ params, session, url }) {
	if (!session?.user) {
		return redirectToLogin(url);
	}

	try {
		const board = await Boards.one(params.boardId);
		return { board };
	} catch (error) {}

	error(404, 'board not found');
}
