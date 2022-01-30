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
	export let objectives;

	let newObjective = { label: '' };

	async function onSubmit() {
		try {
			await db.objectives.insert(newObjective);
			objectives = await db.objectives.all();
		} catch (error) {
			console.error(error);
		}
	}
</script>

<main>
	<h1>Objectives</h1>

	<ul>
		{#each objectives as objective}
			<li>{objective.label}</li>
		{/each}
	</ul>

	<h3>Add Objective</h3>
	<form on:submit|preventDefault={onSubmit}>
		<input type="text" bind:value={newObjective.label} />
		<button>Submit</button>
	</form>
</main>
