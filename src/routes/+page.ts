import type { PageLoad } from './$types';
import { withAuthenticatedSupabase } from '$lib/db/utils';
import Objectives from '$lib/db/objectives';

export const load = (async (event) =>
	withAuthenticatedSupabase(event, async (supabaseClient) => ({
		objectives: await Objectives.all(supabaseClient)
	}))) satisfies PageLoad;
