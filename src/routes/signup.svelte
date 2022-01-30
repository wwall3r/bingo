<script lang="ts">
	import EmailPasswordForm from '$lib/auth/EmailPasswordForm.svelte';
</script>

<div class="container">
	<h1>Sign up</h1>
	<EmailPasswordForm action="/api/signup" button="Sign Up" let:redirect>
		<p>
			Already a member?
			<a
				sveltekit:prefetch
				aria-label="log in"
				href={`/login?redirect=${encodeURIComponent(redirect)}`}
			>
				Log in here
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
