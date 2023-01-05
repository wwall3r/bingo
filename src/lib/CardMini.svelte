<script lang="ts">
	import type { GameCard } from './db/cards';

	export let card: GameCard;
</script>

{#if card && Array.isArray(card.completions)}
	<div class="aspect-square grid gap-1 grid-cols-5 grid-rows-5">
		{#each card.completions as tile}
			<div
				class="aspect-square w-3 h-3 shadow-lg text-info-content rounded border-2 border-info"
				class:bg-success={tile.state === 2}
			/>
		{/each}
	</div>
{/if}
