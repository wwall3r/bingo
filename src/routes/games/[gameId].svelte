<script lang="ts" context="module">
	import Boards from '$lib/db/boards';
	import Games from '$lib/db/games';
	import BoardMini from '$lib/BoardMini.svelte';
	import supabase from '$lib/db';
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ params, session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

		try {
			const game = await Games.one(params.gameId);
			const boards = await Boards.allForGame(params.gameId);
			return { props: { game, boards } };
		} catch (error) {
			console.error(error);
			return { error };
		}
	}
</script>

<script lang="ts">
	import { page, session } from '$app/stores';
	export let game;
	export let boards;

	// TODO: boards/score is a better first UI than players. The list of all players
	// should be accessible but not prevalent.

	const handleNewBoard = async () => {
		await supabase.rpc('create_board', {
			p_game_id: $page.params.gameId,
			p_profile_id: $session.profile_id,
			p_num_objectives: 24
		});
	};
</script>

<button class="btn btn-success" on:click={handleNewBoard}>New Board</button>
<div class="m-2 md:max-w-prose md:mx-auto">
	<h2 class="card-title text-accent">{game.label}</h2>
	<p class="mb-2">{game.description}</p>
	{#each boards as board}
		<a sveltekit:prefetch href="/boards/{board.id}">
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
