import supabase from '$lib/db';

export default async <T>(cmd: () => Promise<T>): Promise<T> => {
	// check for JWT expiration
	const session = supabase.auth.session();
	if (session && session.expires_at * 1000 <= Date.now()) {
		console.log('session expired at ' + new Date(session.expires_at * 1000));
		// TODO: handle expired session
		// if session expired
		// hit auth/refresh endpoint (since refresh cookie is hidden to JS currently)
		// success -> continue
		// error -> redirect to login?
	}

	const { data, error } = await cmd();

	if (error) {
		throw new Error(error.message);
	}

	return data;
};
