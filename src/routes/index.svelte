<script lang="ts" context="module">
	import * as db from '$lib/db';

	export async function load() {
		try {
			const objectives = await db.objectives.all();
			return { props: { objectives } };
		} catch (error) {
			return { error };
		}
	}
</script>

<script lang="ts">
	import { auth, user } from '$lib/db';

	export let objectives;

	let newObjective = { label: '' };

	async function onSubmit() {
		try {
			await db.objectives.insert(newObjective);
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

	<h1>My Favorite Objectives</h1>

	<ul>
		{#each objectives as objective}
			<li>{objective.label}</li>
		{/each}
	</ul>

	<form on:submit|preventDefault={onSubmit}>
		<input type="text" bind:value={newObjective.label} />
		<button>Submit</button>
	</form>
</main>
