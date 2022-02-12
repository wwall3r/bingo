<script>
	import EmailPasswordFormExample from '$lib/auth/EmailPasswordFormExample.svelte';
</script>

<EmailPasswordFormExample action="/api/auth/login" let:redirect>
	<a
		class="btn btn-ghost rounded-btn"
		sveltekit:prefetch
		aria-label="sign up"
		href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}
	>
		Sign Up
	</a>
	<button class="btn btn-primary rounded-btn">Log In</button>
</EmailPasswordFormExample>
