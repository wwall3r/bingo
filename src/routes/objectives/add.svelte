<script lang="ts" context="module">
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

		return { status: 200 };
	}
</script>

<script lang="ts">
	import ObjectiveAdd from '$lib/ObjectiveAdd.svelte';
</script>

<ObjectiveAdd />
