import supabase from '$lib/db';

/** @type {import('./$types').LayoutServerLoad} */
export async function load({ locals }) {
	if (locals.user) {
		const { data, error } = await supabase
			.from('user_profiles')
			.select()
			.eq('user_id', locals.user.id)
			.single();

		if (error) {
			console.log('query profile error', error);
		}

		locals.profile_id = data.id;
	}

	return { user: locals?.user, profile_id: locals?.profile_id };
}
