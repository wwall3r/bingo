<script lang="ts">
	import type { PageData } from './$types';
	import { enhance } from '$app/forms';

	export let data: PageData;

	$: game = data.game;
	$: cards = data.cards;

	// This is a progressive enhancement which allows clicking from the whole row
	const handleCardClick = (evt: Event) => {
		(evt.target as HTMLElement).querySelector('a')?.click();
	};
</script>

<form method="POST" action="?/createCard" use:enhance>
	<button class="btn btn-success">New Card</button>
</form>

{#if game}
	<div class="m-2 md:max-w-prose md:mx-auto">
		<h2 class="card-title text-accent">{game.label}</h2>
		<p class="mb-2">{game.description}</p>

		{#if cards}
			<div class="overflow-x-auto">
				<table class="table table-zebra w-full">
					<thead>
						<tr>
							<th>Card</th>
							<th class="text-right">Score</th>
						</tr>
					</thead>
					<tbody>
						{#each cards as card}
							<tr class="hover cursor-pointer" on:click={handleCardClick}>
								<td>
									<a class="block" href="/cards/{card?.id}">
										{card?.user_profiles.display_name ?? 'Player 1'}
									</a>
								</td>
								<td class="text-right">
									{#if card.scores.score == game.card_size}
										<span class="font-bold text-primary animate-pulse">WINNER!</span>
									{:else}
										{card.scores.score ?? 0}
									{/if}
								</td>
							</tr>
						{/each}
					</tbody>
				</table>
			</div>
		{/if}
	</div>
{/if}
