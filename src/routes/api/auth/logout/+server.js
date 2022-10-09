import supabase from '$lib/db';
import { updateAuthCookies, validateRedirect } from '$lib/auth/helper';

/** @type {import('@sveltejs/kit').RequestHandler} */
export const GET = async (event) => {
	const { request } = event;
	const redirect = new URL(request.url).searchParams?.get('redirect');

	return handleLogOut(event, redirect);
};

/** @type {import('@sveltejs/kit').RequestHandler} */
export const POST = async (event) => {
	const { request } = event;

	const body = await request.formData();
	const redirect = body.get('redirect')?.toString() || '/';

	return handleLogOut(event, redirect);
};

/**
 * @param {any} event
 * @param {string} redirect
 * @return {Response}
 */
const handleLogOut = async (event, redirect) => {
	const { locals } = event;

	if (!validateRedirect(redirect)) {
		redirect = '/';
	}

	if (locals.token) {
		console.log('signing out token', locals.token);
		await supabase.auth.signOut(locals.token);
	}

	const response = new Response(
		JSON.stringify({
			event: 'SIGNED_OUT'
		}),
		{
			status: 302,
			headers: {
				location: redirect || '/'
			}
		}
	);

	updateAuthCookies(response);
	return response;
};
