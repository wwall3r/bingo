import { error } from '@sveltejs/kit';
import Games from '$lib/db/games';
import { redirectToLogin } from '$lib/auth/helper';

/** @type {import('./$types').PageLoad} */
export async function load({ parent, url }) {
	const { user } = await parent();

	if (!user) {
		return redirectToLogin(url);
	}

	try {
		const games = await Games.all();
		return { games };
	} catch (error) {}

	error(404, 'games not found');
}
