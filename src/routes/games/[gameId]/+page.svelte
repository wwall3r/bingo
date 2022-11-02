<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';
	import BoardMini from '$lib/BoardMini.svelte';

	export let data: PageData;

	// TODO: boards/score is a better first UI than players. The list of all players
	// should be accessible but not prevalent.
</script>

<form method="POST" action="?/createBoard" use:enhance>
	<button class="btn btn-success">New Board</button>
</form>
<div class="m-2 md:max-w-prose md:mx-auto">
	<h2 class="card-title text-accent">{data.game.label}</h2>
	<p class="mb-2">{data.game.description}</p>
	{#if data.boards}
		{#each data.boards as board}
			<a href="/boards/{board.id}">
				<div class="card card-side bg-base-200 hover shadow-xl">
					<div class="card-body">
						<h2 class="card-title">
							{board.user_profiles.display_name}
						</h2>
					</div>
					<div class="mr-3 absolute top-0 right-0 bottom-0 flex items-center justify-center">
						<BoardMini {board} />
					</div>
				</div>
			</a>
		{/each}
	{/if}
</div>
