import { createClient } from '@supabase/auth-helpers-sveltekit';
import type { Database } from '@supabase/supabase-js';
import { env } from '$env/dynamic/public';

export const supabaseClient: DataBase = createClient(
	env.PUBLIC_SUPABASE_URL,
	env.PUBLIC_SUPABASE_ANON_KEY
);
