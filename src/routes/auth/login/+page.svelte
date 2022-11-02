<script lang="ts">
	import type { ActionData } from './$types';
	import EmailPasswordForm from '$lib/auth/EmailPasswordForm.svelte';

	export let form: ActionData;
</script>

<EmailPasswordForm {form} let:redirect>
	<a
		class="btn btn-ghost rounded-btn"
		aria-label="sign up"
		href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}
	>
		Sign Up
	</a>
	<button class="btn btn-primary rounded-btn">Log In</button>
</EmailPasswordForm>
