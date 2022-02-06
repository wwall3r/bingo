<script lang="ts" context="module">
	import Games from '$lib/db/games';

	export async function load() {
		try {
			const games = await Games.all();
			return { props: { games } };
		} catch (error) {
			console.error(error);
			return { error };
		}
	}
</script>

<script lang="ts">
	export let games;
</script>

<div>
	{#each games as game}
		<div>
			<a sveltekit:prefetch href="/games/{game.id}"><h4>{game.label}</h4></a>
			<p>{game.description}</p>
		</div>
	{/each}
	{#if !games?.length}
		<p>You are not a member of any games. Try starting one yourself!</p>
	{/if}
</div>
