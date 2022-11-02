<script lang="ts">
	import type { PageData } from './$types';
	import Objectives from '$lib/db/objectives';

	export let data: PageData;
	$: objectives = data.objectives;

	let newObjective = { label: '' };

	async function onSubmit() {
		try {
			await Objectives.insert(newObjective);
		} catch (error) {
			console.error(error);
		}
	}
</script>

<h1>My Favorite Objectives</h1>

{#if objectives}
	<ul>
		{#each objectives as objective}
			<li>{objective.label}</li>
		{/each}
	</ul>
{/if}

<form on:submit|preventDefault={onSubmit}>
	<input type="text" bind:value={newObjective.label} />
	<button>Submit</button>
</form>
