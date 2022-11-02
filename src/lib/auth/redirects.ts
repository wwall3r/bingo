import type { RequestEvent } from '@sveltejs/kit';
import { redirect } from '@sveltejs/kit';

export const validateRedirect = (redirect: string): boolean => /^\/\w?/.test(redirect);

export const getRelativePath = (url: URL | string): string =>
	url.pathname == '/auth/login' || url.pathname == '/auth/signup'
		? url.searchParams.get('redirect')
		: url.toString().substring(url.origin.length);

export const redirectToPage = async (event: RequestEvent) => {
	const uri = event.url.searchParams.get('redirect');

	if (!uri) {
		const formData = await event.request.formData();
		uri = formData.get('redirect');
	}

	return redirect(303, validateRedirect(uri) ? uri : '/');
};

export const redirectToLogin = (event: RequestEvent) =>
	redirect(303, '/auth/login?redirect=' + encodeURIComponent(getRelativePath(event.url)));
