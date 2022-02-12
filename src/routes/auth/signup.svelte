<script lang="ts">
	import EmailPasswordFormExample from '$lib/auth/EmailPasswordFormExample.svelte';
</script>

<EmailPasswordFormExample action="/api/auth/login" let:redirect>
	<a
		class="btn btn-ghost rounded-btn"
		sveltekit:prefetch
		aria-label="log in"
		href={`/auth/login?redirect=${encodeURIComponent(redirect)}`}
	>
		Log In
	</a>
	<button class="btn btn-primary rounded-btn">Sign Up</button>
</EmailPasswordFormExample>
