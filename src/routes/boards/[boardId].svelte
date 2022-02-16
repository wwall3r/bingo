<script lang="ts" context="module">
	import Boards from '$lib/db/boards';
	import { redirectToLogin } from '$lib/auth/helper';

	export async function load({ params, session, url }) {
		if (!session?.user) {
			return redirectToLogin(url);
		}

		try {
			const completions = [];
			for (let i = 0; i < 25; i++) {
				const num = i + 1;
				completions[i] = {
					id: num,
					notes: '',
					state: i % 5 === 4 ? 'wahoo' : '',
					objective: { id: num, label: num, description: num.toString() }
				};
			}

			const board =
				//await Boards.one(params.boardId);
				{
					id: 'nope',
					user_profiles: {
						id: -1,
						display_name: 'Batman'
					},
					completions
				};
			return { props: { board } };
		} catch (error) {
			console.error(error);
			return { error };
		}
	}
</script>

<script lang="ts">
	export let board;
	// TODO: why is state text? Should that not be a boolean?

	// TODO: size is computable from board.completions.length, but that mucks
	// up tailwind. Set manually?
</script>

<div class="grid gap-2 grid-cols-5 grid-rows-5 md:max-w-prose md:mx-auto">
	{#each board.completions as tile}
		<div
			class="p-4 aspect-square bg-info shadow-lg text-info-content rounded-lg flex justify-center items-center"
			class:bg-success={tile.state}
			class:text-success-content={tile.state}
		>
			<span class="align-middle">{tile.objective.label}</span>
		</div>
	{/each}
</div>
