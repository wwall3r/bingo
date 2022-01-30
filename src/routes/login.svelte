<script lang="ts">
	import EmailPasswordForm from '$lib/auth/EmailPasswordForm.svelte';
</script>

<div class="container">
	<h1>Log in</h1>
	<EmailPasswordForm action="/api/login" button="Log in" let:redirect>
		<p>
			Not a member?
			<a
				sveltekit:prefetch
				aria-label="sign up"
				href={`/signup?redirect=${encodeURIComponent(redirect)}`}
			>
				Sign up here
			</a>
		</p>
	</EmailPasswordForm>
</div>

<style>
	.container {
		display: flex;
		flex-direction: column;
		width: 25rem;
	}
</style>
