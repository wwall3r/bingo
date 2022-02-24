import supabase from '$lib/db';
import { serialize } from 'cookie-es';

/**
 * @param {string} path
 * @param {'signIn' | 'signUp'} method
 * @return {import('@sveltejs/kit').RequestHandler}
 */
export const createHandler =
	(path, method) =>
	async ({ request }) => {
		const body = await request.formData();
		const email = body.get('email').toString();
		const password = body.get('password').toString();
		const redirect = body.get('redirect').toString() || '/';

		const { session, error } = await supabase.auth[method]({ email, password });

		if (!validateRedirect(redirect)) {
			return getErrorResponse('invalid redirect', '/', path);
		}

		if (error) {
			console.error(error);
			return getErrorResponse(error.message, redirect, path);
		} else {
			console.log('session', session);
		}

		const response = getSuccessResponse(session, redirect);
		updateAuthCookie(response, session);
		return response;
	};

/**
 * @param {string} redirect
 * @return {boolean}
 */
export const validateRedirect = (redirect) => /^\/\w?/.test(redirect);

/**
 * @param {URL} url
 * @return {string} the path to use for redirect through /auth endpoints and pages
 */
export const getRelativePath = (url) =>
	url.pathname.startsWith('/auth/')
		? url.searchParams.get('redirect')
		: url.toString().substring(url.origin.length);

/**
 * @param {URL} url
 */
export const redirectToLogin = (url) => ({
	status: 302,
	redirect: '/auth/login?redirect=' + encodeURIComponent(getRelativePath(url))
});

/**
 * @param {import('@sveltejs/kit').EndpointOutput} response
 * @param {Session?} session
 */
export const updateAuthCookie = async (response, session) => {
	response.headers['set-cookie'] = [
		serialize('sb:token', session?.access_token || '', {
			httpOnly: false,
			maxAge: session?.expires_in || -1,
			path: '/',
			sameSite: 'lax'
		}),
		serialize('sb:refresh', session?.refresh_token || '', {
			httpOnly: true,
			maxAge: 2 * (session?.expires_in || -1),
			path: '/',
			sameSite: 'lax'
		})
	];
};

/**
 * @param {string} error
 * @param {string} redirect
 * @param {string} path
 * @return {import('@sveltejs/kit').EndpointOutput}
 */
const getErrorResponse = (error, redirect, path) => {
	const params = new URLSearchParams();
	params.set('error', error);
	params.set('redirect', redirect);

	return {
		status: 302,
		body: 'error',
		headers: {
			location: `${path}?${params.toString()}`
		}
	};
};

/**
 * @param {import('@supabase/gotrue-js').Session} session
 * @param {string} redirect
 * @return {import('@sveltejs/kit').EndpointOutput}
 */
const getSuccessResponse = (session, redirect) => ({
	status: 302,
	body: {
		event: 'SIGNED_IN',
		session
	},
	headers: {
		location: redirect || '/'
	}
});
