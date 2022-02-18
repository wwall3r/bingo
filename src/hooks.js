import { toExpressRequest } from '$lib/auth/expressify';
import supabase from '$lib/db';

/** @type {import('@sveltejs/kit').Handle} */
export const handle = async ({ event, resolve }) => {
	const { locals, request } = event;

	const expressRequest = toExpressRequest(request);
	const { user } = await supabase.auth.api.getUserByCookie(expressRequest);

	locals.token = expressRequest.cookies['sb:token'] || undefined;
	locals.user = user || false;

	supabase.auth.setAuth(locals.token);

	if (!locals.profile_id && locals.user) {
		const { data, error } = await supabase
			.from('user_profiles')
			.select()
			.eq('user_id', locals.user.id)
			.single();
		if (error) {
			console.log(error);
		}
		locals.profile_id = data.id;
	}

	return resolve(event);
};

/** @type {import('@sveltejs/kit').GetSession} */
export const getSession = async (request) => request.locals;
