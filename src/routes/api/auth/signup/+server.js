import { createHandler } from '$lib/auth/helper';

export const POST = createHandler('/auth/signup', 'signUp');
