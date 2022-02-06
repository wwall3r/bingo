<script lang="ts">
	import { session } from '$app/stores';
	import LogInOutFormExample from '$lib/auth/LogInOutFormExample.svelte';
</script>

<main>
	{#if $session.user}
		<a sveltekit:prefetch href="/games" aria-label="My Games">Games</a>
		|
	{/if}
	<LogInOutFormExample />
	<slot />
</main>
