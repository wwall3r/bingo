<script lang="ts">
	import Auth from 'supabase-ui-svelte';
	import { supabase } from '$lib/db';
</script>

<div class="container">
	<h1>Sign in</h1>
	<Auth supabaseClient={supabase} view="magic_link" />
</div>

<style>
	.container {
		display: flex;
		flex-direction: column;
		width: 25rem;
		margin: 0px auto;
	}
</style>
