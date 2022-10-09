import { createHandler } from '$lib/auth/helper';

export const POST = createHandler('/auth/login', 'signIn');
