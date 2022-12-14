import type { Actions } from './$types';
import { fail } from '@sveltejs/kit';
import { withAuthenticatedSupabase } from '$lib/db/utils';
import Objectives from '$lib/db/objectives';
import Operators from '$lib/db/operators';

export const actions = {
	save: async (event) =>
		withAuthenticatedSupabase(event, async (supabaseClient) => {
			const formData = await event.request.formData();

			const label = formData?.get('label')?.toString() || '';
			const description = formData?.get('description')?.toString() || '';

			if (!label) {
				return fail(400, {
					error: 'Please provide a label',
					label,
					description
				});
			}

			await Objectives.insert(supabaseClient, { label, description });
			return {
				canSave: false,
				label: '',
				description: '',
				success: true,
				similar: null
			};
		}),

	similar: async (event) =>
		withAuthenticatedSupabase(event, async (supabaseClient) => {
			const formData = await event.request.formData();

			const label = formData?.get('label')?.toString() || '';
			const description = formData?.get('description')?.toString() || '';

			if (!label) {
				return fail(400, {
					error: 'Please provide a label',
					label,
					description
				});
			}

			return {
				canSave: true,
				description,
				label,
				similar: await Objectives.search(supabaseClient, label, Operators.OR)
			};
		})
} satisfies Actions;
