<script lang="ts">
	import type { GameBoard } from './db/boards';

	export let board: GameBoard;
</script>

{#if board && Array.isArray(board.completions)}
	<div class="aspect-square grid gap-1 grid-cols-5 grid-rows-5">
		{#each board.completions as tile}
			<div
				class="aspect-square w-3 h-3 bg-info shadow-lg text-info-content rounded"
				class:bg-success={tile.state === 2}
			/>
		{/each}
	</div>
{/if}
