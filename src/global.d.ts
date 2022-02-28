/// <reference types="@sveltejs/kit" />

import { User } from '@supabase/gotrue-js';

interface SessionData {
	token?: string;
	user: User | false;
	profile_id?: string;
}

// Override Svelte Kit's default types with our defined session type
declare namespace App {
	interface Locals extends SessionData {}
	interface Session extends SessionData {}
}
