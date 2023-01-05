import type { Actions } from './$types';
import { fail } from '@sveltejs/kit';
import { withAuthenticatedSupabase } from '$lib/db/utils';
import Completion from '$lib/db/completion';

export const actions = {
	toggle: async (event) =>
		withAuthenticatedSupabase(event, async (supabaseClient) => {
			const formData = await event.request.formData();
			const id = formData?.get('completionId') as string;

			if (!id) {
				return fail(400, {
					error: 'Must provide a completion ID'
				});
			}

			const completion = await Completion.state(supabaseClient, id);

			if (completion) {
				await Completion.update(supabaseClient, {
					id,
					state: completion.state === 1 ? 2 : 1
				});
			}
		})
} satisfies Actions;
