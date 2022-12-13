<script lang="ts">
	import type { PageData } from './$types';

	export let data: PageData;
</script>

<h1>My Favorite Objectives</h1>

{#if data.objectives}
	<ul>
		{#each data.objectives as objective}
			<li>{objective.label}</li>
		{/each}
	</ul>
{/if}
