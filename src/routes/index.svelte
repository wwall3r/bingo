<script lang="ts" context="module">
	import Objectives from '$lib/db/objectives';

	export async function load() {
		try {
			const objectives = await Objectives.all();
			return { props: { objectives } };
		} catch (error) {
			return { error };
		}
	}
</script>

<script lang="ts">
	import LogInOutFormExample from '$lib/auth/LogInOutFormExample.svelte';

	export let objectives;

	let newObjective = { label: '' };

	async function onSubmit() {
		try {
			await Objectives.insert(newObjective);
		} catch (error) {
			console.error(error);
		}
	}
</script>

<main>
	<LogInOutFormExample/>
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
