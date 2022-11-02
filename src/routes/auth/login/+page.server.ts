import type { Actions } from './$types';
import { getPasswordAction } from '$lib/auth/form';

export const actions: Actions = {
	default: getPasswordAction('signInWithPassword')
};
