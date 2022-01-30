import { parse as cookieParse } from 'cookie-es';
import { auth } from '$lib/db';
import { validateRedirect } from '$lib/auth';
import type { EndpointOutput, RequestHandler } from '@sveltejs/kit';

export const post: RequestHandler = async ({ request }): Promise<EndpointOutput> => {
	// TODO: telemetry
	const cookies: Record<string, string> = cookieParse(request.headers.get('cookie')) || '';

	const body = await request.formData();
	let redirect = body.get('redirect')?.toString() || '/';

	if (!validateRedirect(redirect)) {
		// TODO: send error to ui or nah?
		redirect = '/';
	}

	if (cookies.access_token) {
		// TODO: do we care about errors on logout?
		await auth.signOut(cookies.access_token);
	}

	return {
		status: 302,
		body: 'success',
		headers: {
			'set-cookie': getDeletedCookies(),
			location: redirect || '/'
		}
	};
};

const getDeletedCookies = (): string[] => {
	const cookieOptions = `Path=/;Secure;SameSite=Strict;Expires=${new Date(0).toUTCString()};`;

	return [
		`refresh_token=deleted;${cookieOptions}`,
		`access_token=deleted;${cookieOptions}`,
		`expires_at=deleted;${cookieOptions}`
	];
};
