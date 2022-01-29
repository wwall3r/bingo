<script lang="ts" context="module">
	import * as db from '$lib/db';

	export async function load() {
		try {
			const games = await db.games.all();
			return { props: { games } };
		} catch (error) {
			return { error };
		}
	}
</script>

<script lang="ts">
	import { auth, user } from '$lib/db';

	export let games;

	let newGame = { title: '' };

	async function onSubmit() {
		try {
			await db.games.insert(newGame);
		} catch (error) {
			console.error(error);
		}
	}
</script>

<main>
	{#if $user}
		<p>You are signed in as {$user.email}</p>
		<button on:click={() => auth.signOut()}>Sign out</button>
	{:else}
		<nav>
			<a href="/sign-in">Sign in</a>
		</nav>
	{/if}

	<h1>My Favorite Games</h1>

	<ul>
		{#each games as game}
			<li>{game.title}</li>
		{/each}
	</ul>

	<form on:submit|preventDefault={onSubmit}>
		<input type="text" bind:value={newGame.title} />
		<button>Submit</button>
	</form>
</main>
