<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';
	import CardMini from '$lib/CardMini.svelte';

	export let data: PageData;

	$: wins = data?.wins;

	// TODO: cards/score is a better first UI than players. The list of all players
	// should be accessible but not prevalent.
</script>

<form method="POST" action="?/createCard" use:enhance>
	<button class="btn btn-success">New Card</button>
</form>
{#if data?.game}
	<div class="m-2 md:max-w-prose md:mx-auto">
		<h2 class="card-title text-accent">{data.game.label}</h2>
		<p class="mb-2">{data.game.description}</p>
		{#if data.cards}
			{#each data.cards as card}
				{#if card}
					<a class="block mb-2" href="/cards/{card.id}">
						<div class="card card-side bg-base-200 hover shadow-xl">
							<div class="card-body">
								<h2 class="card-title">
									{card.user_profiles.display_name}
								</h2>
							</div>
							<div class="mr-3 absolute top-0 right-0 bottom-0 flex items-center justify-center">
								<CardMini {card} {wins} />
							</div>
						</div>
					</a>
				{/if}
			{/each}
		{/if}
	</div>
{/if}
