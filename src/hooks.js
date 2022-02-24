import supabase from '$lib/db';
import { parse } from 'cookie-es';

/** @type {import('@sveltejs/kit').Handle} */
export const handle = async ({ event, resolve }) => {
	const { locals, request } = event;

	const cookies = request?.headers.get('cookie');
	let token;

	if (cookies) {
		const parsed = parse(cookies);
		token = parsed['sb:token'];

		if (!token && parsed['sb:refresh']) {
			const { session, error } = await supabase.auth.signIn({
				refreshToken: parsed['sb:refresh']
			});

			if (error) {
				console.error('could not sign in with refresh token', error);
			}

			token = session.access_token;

			// TODO: bump sb:refresh cookie maxAge or expiration
		}

		if (token) {
			const { user, error } = await supabase.auth.api.getUser(token);

			if (error) {
				console.error('could not get user with access_token', error);
			}

			locals.token = token || undefined;
			locals.user = user || false;
		}
	}

	supabase.auth.setAuth(token);

	if (!locals.profile_id && locals.user) {
		const { data, error } = await supabase
			.from('user_profiles')
			.select()
			.eq('user_id', locals.user.id)
			.single();

		if (error) {
			console.log('could not query profile', error);
		}

		locals.profile_id = data.id;
	}

	return resolve(event);
};

/** @type {import('@sveltejs/kit').GetSession} */
export const getSession = async (request) => request.locals;
