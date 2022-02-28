<script lang="ts" context="module">
	import Boards from '$lib/db/boards';
	import type { GameBoard } from '$lib/db/boards';
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ params, session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

		try {
			const board = await Boards.one(params.boardId);
			return { props: { board } };
		} catch (error) {
			console.error(error);
			return { error };
		}
	}
</script>

<script lang="ts">
	import { fly } from 'svelte/transition';
	import { scaledContent } from '$lib/scaledContent';
	import CompletionDetails from '$lib/CompletionDetails.svelte';
	export let board: GameBoard;

	let completion;

	// TODO: size is computable from board.completions.length, but that mucks
	// up tailwind. Set manually?

	// TODO: May want to drop the board and profile display name on here
	const duration = 500;
	const transitionOptions = {
		duration,
		delay: duration
	};

	const getTransitionOptions = (i) => {
		const x = i % 5;
		const y = Math.floor(i / 5);

		return Object.assign({}, transitionOptions, {
			x: (2 - x) * 200,
			y: (2 - y) * 200
		});
	};

	const completionHandler = (c) => {
		console.log('Button clicked for completion');
		console.log(c);
		completion = c;
	};
</script>

<div
	class="mt-2 mx-1 grid gap-2 grid-cols-5 grid-rows-5 md:max-w-prose md:mx-auto"
	transition:fly={transitionOptions}
>
	{#each board.completions as tile, i}
		<button
			aria-label={tile.objectives.label}
			class="btn aspect-square h-auto"
			class:btn-success={tile.state === 2}
			use:scaledContent
			on:click={() => {
				completionHandler(tile);
			}}
			in:fly={getTransitionOptions(i)}
		>
			<span class="scaled-content">
				{tile.objectives.label}
			</span>
		</button>
	{/each}
</div>

{#if completion}
	<CompletionDetails {completion} />
{/if}
