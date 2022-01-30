import { auth } from '$lib/db';
import type { EndpointOutput, RequestHandler } from '@sveltejs/kit';
import type { Session } from '@supabase/gotrue-js';

type Method = 'signIn' | 'signUp';

export const createHandler =
	(path: string, method: Method): RequestHandler =>
	async ({ request }): Promise<EndpointOutput> => {
		// TODO: telemetry

		const body = await request.formData();
		const email = body.get('email')?.toString();
		const password = body.get('password')?.toString();
		const redirect = body.get('redirect')?.toString() || '/';

		const { session, error } = await auth[method]({ email, password });

		if (!validateRedirect(redirect)) {
			return getErrorResponse('invalid redirect', '/', path);
		}

		if (error) {
			return getErrorResponse(error.message, redirect, path);
		}

		return getSuccessResponse(session, redirect);
	};

export const validateRedirect = (redirect: string): boolean => /^\/\w?/.test(redirect);

// TODO: telemetry?
const getErrorResponse = (error: string, redirect: string, path: string): EndpointOutput => {
	const params = new URLSearchParams();
	params.set('error', error);
	params.set('redirect', redirect);

	return {
		status: 302,
		body: 'error',
		headers: {
			// TODO: consider putting these in the fragment?
			location: `${path}?${params.toString()}`
		}
	};
};

// TODO: telemetry?
const getSuccessResponse = (session: Session, redirect: string): EndpointOutput => ({
	status: 302,
	body: 'success',
	headers: {
		'set-cookie': constructCookies(session),
		location: redirect || '/'
	}
});

const constructCookies = (session: Session): string[] => {
	const cookieOptions = `Path=/;Secure;SameSite=Strict;Expires=${new Date(
		session.expires_at * 1000
	).toUTCString()};`;

	return [
		`refresh_token=${session.refresh_token};${cookieOptions}`,
		`access_token=${session.access_token};${cookieOptions}`,
		`expires_at=${session.expires_at};${cookieOptions}`
	];
};
