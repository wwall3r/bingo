<script lang="ts">
	import { session } from '$app/stores';
</script>

<nav>
	{#if $session.user}
		<span>{$session.user.email}</span>
		<form class="inline" action="/api/logout" method="post">
			<button aria-label="log out">Log out</button>
		</form>
	{:else}
		<a href="/login">Log in</a>
	{/if}
</nav>
<slot />

<style>
	.inline {
		display: inline-block;
	}
</style>
