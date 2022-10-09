<script lang="ts">
	import { page, session } from '$app/stores';
	import { invalidateAll } from '$app/navigation';
	import supabase from '$lib/db';
	import BoardMini from '$lib/BoardMini.svelte';

	/** @type {import('./$types').PageLoad} */
	export let data;

	$: game = data.game;
	$: boards = data.boards;

	// TODO: boards/score is a better first UI than players. The list of all players
	// should be accessible but not prevalent.

	const handleNewBoard = async () => {
		const { error } = await supabase.rpc('create_board', {
			p_game_id: $page.params.gameId,
			p_profile_id: $session.profile_id,
			p_num_objectives: 24
		});

		if (!error) {
			invalidateAll();
		} else {
			console.log(error);
		}
	};
</script>

<button class="btn btn-success" on:click={handleNewBoard}>New Board</button>
<div class="m-2 md:max-w-prose md:mx-auto">
	<h2 class="card-title text-accent">{game.label}</h2>
	<p class="mb-2">{game.description}</p>
	{#each boards as board}
		<a data-sveltekit-prefetch href="/boards/{board.id}">
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
</div>
