<script lang="ts" context="module">
	import { UserProfile } from './../../lib/db/user_profiles.ts';
	import supabase from '$lib/db';
	import Games from '$lib/db/games';
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ params, session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

		try {
			const game = await Games.one(params.gameId);
			const players = await Games.members(params.gameId);
			return { props: { game, players } };
		} catch (error) {
			console.error(error);
			return { error };
		}
	}
</script>

<script lang="ts">
	import { page, session } from '$app/stores';
	export let game;
	export let players;

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
	<div class="overflow-x-auto">
		<table class="table w-full">
			<thead>
				<tr>
					<th>Name</th>
					<th>Board</th>
					<th>Status</th>
				</tr>
			</thead>
			<tbody>
				{#each players as player, i}
					<tr>
						<td>{player.display_name}</td>
						<td>board #{i}</td>
						<td>not yet</td>
					</tr>
				{/each}
			</tbody>
		</table>
	</div>
</div>
