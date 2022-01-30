import { createHandler } from '$lib/auth';

export const post = createHandler('/login', 'signIn');
