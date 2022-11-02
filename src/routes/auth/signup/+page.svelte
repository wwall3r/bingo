<script lang="ts">
	import type { ActionData } from './$types';
	import EmailPasswordForm from '$lib/auth/EmailPasswordForm.svelte';

	export let form: ActionData;
</script>

<EmailPasswordForm {form} let:redirect>
	<a
		class="btn btn-ghost rounded-btn"
		aria-label="log in"
		href={`/auth/login?redirect=${encodeURIComponent(redirect)}`}
	>
		Log In
	</a>
	<button class="btn btn-primary rounded-btn">Sign Up</button>
</EmailPasswordForm>
