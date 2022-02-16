<script lang="ts" context="module">
	import Games from '$lib/db/games';
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

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

{#if !games?.length}
	<p>You are not a member of any games. Try starting one yourself!</p>
{:else}
	{#each games as game}
		<a sveltekit:prefetch href="/games/{game.id}">
			<div
				class="m-2 p-2 card card-compact card-bordered md:card-normal hover:bg-base-200 md:max-w-prose md:mx-auto"
			>
				<div class="card-body">
					<h2 class="card-title text-accent">
						{game.label}
					</h2>
					<p>{game.description}</p>
				</div>
			</div>
		</a>
	{/each}
{/if}
