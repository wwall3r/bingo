<script lang="ts" context="module">
	import Boards from '$lib/db/boards';
	import type { Board } from '$lib/db/boards';
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
	import { scaledContent } from '$lib/scaledContent';
	export let board: Board;

	// TODO: size is computable from board.completions.length, but that mucks
	// up tailwind. Set manually?
</script>

<div class="mt-2 grid gap-2 grid-cols-5 grid-rows-5 md:max-w-prose md:mx-auto">
	{#each board.completions as tile}
		<div
			class="p-1 aspect-square border-2 border-info shadow-lg text-info-content rounded-lg flex justify-center items-center"
			class:border-success={tile.state === 2}
			use:scaledContent
		>
			<div class="scaled-content text-center invisible">
				{tile.objectives.label}
			</div>
		</div>
	{/each}
</div>
