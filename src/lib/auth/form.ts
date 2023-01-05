import { getSupabase } from '@supabase/auth-helpers-sveltekit';
import { AuthApiError } from '@supabase/supabase-js';
import { fail } from '@sveltejs/kit';
import { redirectToPage } from './redirects';

import type { RequestEvent } from '@sveltejs/kit';

export const getPasswordAction =
	(method: 'signUp' | 'signInWithPassword') => async (event: RequestEvent) => {
		const { request } = event;
		const { supabaseClient } = await getSupabase(event);
		const formData = await request.formData();

		const email = formData.get('email') as string;
		const password = formData.get('password') as string;

		if (!email) {
			return fail(400, {
				error: 'Please enter your email'
			});
		}

		if (!password) {
			return fail(400, {
				error: 'Please enter your password',
				values: {
					email
				}
			});
		}

		const { error } = await supabaseClient.auth[method]({ email, password });

		if (error) {
			if (error instanceof AuthApiError) {
				if (method === 'signUp') {
					console.error(error);
				}

				return fail(error.status, {
					error: 'fail credentials.',
					values: {
						email
					}
				});
			}

			console.error(error);

			return fail(500, {
				error: 'Server error. Please try again later.',
				values: {
					email
				}
			});
		}

		throw await redirectToPage(event);
	};
