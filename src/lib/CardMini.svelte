<script lang="ts">
	import type { GameCard } from './db/cards';

	export let card: GameCard;
	export let wins: Set<string>;
</script>

{#if card && Array.isArray(card.completions)}
	<div class="aspect-square grid gap-1 grid-cols-5 grid-rows-5">
		{#each card.completions as tile}
			<div
				class="aspect-square w-3 h-3 shadow-lg text-info-content rounded border-2 border-info"
				class:animate-[spin_2s_ease-in-out_infinite]={wins.has(tile.id)}
				class:border-primary={wins.has(tile.id)}
				class:bg-primary={wins.has(tile.id)}
				class:border-success={!wins.has(tile.id) && tile.state === 2}
				class:bg-success={!wins.has(tile.id) && tile.state === 2}
			/>
		{/each}
	</div>
{/if}
