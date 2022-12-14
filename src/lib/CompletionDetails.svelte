<svelte:options accessors={true} />

<script lang="ts">
	import type { GameCompletions } from '$lib/db/boards';
	export let completion: GameCompletions;

	// import { createEventDispatcher } from 'svelte';
	// let shown = false;
	// let dispatch = createEventDispatcher();
	// export function show() {
	// 	shown = !shown;
	// 	dispatch('show', shown);
	// }
</script>

<!-- {#if shown} -->
<div class="card w-96 bg-base-100 shadow-xl">
	<div class="card-body">
		<h2 class="card-title">{completion.objectives.label}</h2>
		{completion.objectives.description}

		{JSON.stringify(completion)}
		{console.log(completion)}
		<div class="justify-end card-actions">
			<!-- <button on:click={show} class="btn btn-primary">Save</button> -->
			<button class="btn btn-primary">Save</button>
		</div>
	</div>
</div>
<!-- {/if} -->
