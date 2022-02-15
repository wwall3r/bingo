<script lang="ts">
	import Objectives, { type Objective } from '$lib/db/objectives';
	import Operators from '$lib/db/operators';

	let label: string = '';
	let description: string = '';
	let error = false;

	let searchPromise: Promise<Objective[]>;

	const searchSimilar = () => {
		searchPromise = Objectives.search(label, Operators.OR);
	};

	const onSubmit = (event) => {};
</script>

<form on:submit|preventDefault={onSubmit}>
	<div class="form-control">
		<label for="label" class="label">
			<span class="label-text">Label</span>
		</label>
		<input
			name="label"
			type="text"
			aria-label="Objective Label"
			class="input input-bordered"
			class:input-error={error}
			required
			on:blur={searchSimilar}
			bind:value={label}
		/>
	</div>

	{#if searchPromise}
		<div>
			{#await searchPromise}
				Loading similar items...
			{:then similar}
				{#each similar as objective}
					<div class="flex justify-between">
						<span>{objective.label}</span>
						<span>
							{#each objective.tags as tag}
								<span class="badge">{tag.label}</span>
							{/each}
						</span>
					</div>
				{/each}
			{/await}
		</div>
	{/if}

	<div class="form-control">
		<label for="description" class="label">
			<span class="label-text">Description</span>
		</label>
		<textarea name="description" class="textarea textarea-bordered" bind:value={description} />
	</div>
</form>
