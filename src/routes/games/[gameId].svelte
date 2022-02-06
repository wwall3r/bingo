<script lang="ts" context="module">
	import Games from '$lib/db/games';

	export async function load({ params }) {
		try {
			const game = await Games.one(params.gameId);
			const members = await Games.members(params.gameId);
			return { props: { game, members } };
		} catch (error) {
			console.error(error);
			return { error };
		}
	}
</script>

<script lang="ts">
	export let game;
	export let members;
</script>

<h1>{game.label}</h1>
<div>
	<h3>Members</h3>
	{#each members as member}
		<div>{member.display_name}</div>
	{/each}

	<h3>Boards</h3>
	<p>TODO: implement</p>
</div>
