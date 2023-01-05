<script lang="ts">
	import type { PageData } from './$types';
	import { fly } from 'svelte/transition';
	import { enhance } from '$app/forms';
	import { afterNavigate } from '$app/navigation';
	import { scaledContent } from '$lib/scaledContent';

	export let data: PageData;

	$: card = data.card;
	$: game = data.game;

	// TODO: size is computable from card.completions.length, but that mucks
	// up tailwind. Set manually?

	// TODO: May want to drop the card and profile display name on here
	let duration = 500;

	$: transitionOptions = {
		duration,
		delay: duration
	};

	afterNavigate(({ from }) => {
		duration = from === null ? 500 : 0;
	});

	const getTransitionOptions = (key: string, i: number) => {
		const x = i % 5;
		const y = Math.floor(i / 5);

		return Object.assign({}, transitionOptions, {
			key,
			x: (2 - x) * 200,
			y: (2 - y) * 200
		});
	};
</script>

{#if card && game}
	<div class="mt-3 mx-1 flex justify-center md:max-w-prose md:mx-auto md:justify-start">
		<h1 class="text-xl font-semibold">
			<a class="link link-hover link-accent" href={`/games/${game.id}`}>{game.label}</a> &ndash;
			{card.user_profiles.display_name}
		</h1>
	</div>
	<div
		class="mt-3 mx-1 grid gap-2 grid-cols-5 grid-rows-5 md:max-w-prose md:mx-auto"
		in:fly={transitionOptions}
	>
		{#each card.completions as completion, i}
			<label
				for={completion.id}
				aria-label={completion.objectives.label}
				class="btn aspect-square h-auto"
				class:btn-success={completion.state === 2}
				in:fly={getTransitionOptions(completion.id, i)}
				use:scaledContent
			>
				<span class="scaled-content">
					{completion.objectives.label}
				</span>
			</label>

			{#if completion.id !== 'free-space'}
				<input type="checkbox" id={completion.id} class="modal-toggle" />

				<label for={completion.id} class="modal">
					<div class="modal-box relative">
						<h3 class="text-lg font-bold">{completion.objectives.label}</h3>
						{#if completion.objectives.description}
							<p class="py-4">{completion.objectives.description}</p>
						{/if}
						<div class="modal-action">
							{#if data?.session?.user.id === card.user_profiles.id}
								<label for={completion.id} class="btn">Cancel</label>
								<form method="POST" action="?/toggle" use:enhance>
									<input type="hidden" name="completionId" value={completion.id} />

									<button aria-label={completion.state === 2 ? 'Reset' : 'Mark Complete'}>
										<label
											for={completion.id}
											class="btn"
											class:btn-success={completion.state === 1}
											class:btn-primary={completion.state === 2}
										>
											{completion.state === 2 ? 'Reset' : 'Mark Complete'}
										</label>
									</button>
								</form>
							{:else}
								<label for={completion.id} class="btn">Close</label>
							{/if}
						</div>
					</div>
				</label>
			{/if}
		{/each}
	</div>
{/if}
