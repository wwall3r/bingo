import { getSupabase } from '@supabase/auth-helpers-sveltekit';
import { AuthApiError } from '@supabase/supabase-js';
import { invalid, type ValidationError } from '@sveltejs/kit';
import { redirectToPage } from './redirects';

export const getPasswordAction =
	(method: 'signUp' | 'signInWithPassword') =>
	async (event): Promise<ValidationError<{ error: string; values?: { email: string } }>> => {
		const { request } = event;
		const { supabaseClient } = await getSupabase(event);
		const formData = await request.formData();

		const email = formData.get('email') as string;
		const password = formData.get('password') as string;

		if (!email) {
			return invalid(400, {
				error: 'Please enter your email'
			});
		}

		if (!password) {
			return invalid(400, {
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

				return invalid(error.status, {
					error: 'Invalid credentials.',
					values: {
						email
					}
				});
			}

			console.error(error);

			return invalid(500, {
				error: 'Server error. Please try again later.',
				values: {
					email
				}
			});
		}

		throw await redirectToPage(event);
	};
