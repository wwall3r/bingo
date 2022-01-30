import { parse as cookieParse } from 'cookie-es';
import { auth } from '$lib/db';
import type { GetSession, Handle } from '@sveltejs/kit';

export const handle: Handle = async ({ event, resolve }) => {
	const cookies: Record<string, string> = cookieParse(event.request.headers.get('cookie') || '');
	const { user } = await auth.api.getUser(cookies.access_token);
	event.locals.user = user || false;
	return resolve(event);
};

export const getSession: GetSession = async (request) => request.locals;
