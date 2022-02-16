<script lang="ts">
	import ObjectiveAdd from '$lib/ObjectiveAdd.svelte';
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

		return { status: 200 };
	}
</script>

<ObjectiveAdd />
