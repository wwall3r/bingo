import { error } from '@sveltejs/kit';
import { redirectToLogin } from '$lib/auth/helper';

export function load({ session, url }) {
	if (!session?.user) {
		return redirectToLogin(url);
	}

	return { status: 200 };
}
