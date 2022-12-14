<script lang="ts">
	import { enhance } from '$app/forms';
	import type { ActionData } from './$types';

	export let form: ActionData;
</script>

<div class="m-2 p-2 card card-compact card-bordered md:card-normal md:max-w-md md:mx-auto">
	<div class="card-body">
		<form method="POST" action="?/save" use:enhance>
			<div class="form-control">
				<label for="label" class="label">
					<span class="label-text">Label</span>
				</label>
				<input
					name="label"
					type="text"
					aria-label="Objective Label"
					class="input input-bordered"
					class:input-error={form?.error}
					value={form?.label ?? ''}
					required
				/>
			</div>

			<div class="form-control">
				<label for="description" class="label">
					<span class="label-text">Description</span>
				</label>
				<textarea
					name="description"
					class="textarea textarea-bordered"
					value={form?.description ?? ''}
				/>
			</div>

			<div class="card-actions justify-end">
				<button class="btn btn-success" formaction="?/similar">Check for Similar</button>
			</div>

			{#if form?.similar}
				<div>
					{#each form?.similar as objective}
						<div class="flex justify-between">
							<span>{objective.label}</span>
							<span>
								{#each objective.tags as tag}
									<span class="badge">{tag.label}</span>
								{/each}
							</span>
						</div>
					{/each}
					{#if !form?.similar.length}
						<div>No similar items were found.</div>
					{/if}
				</div>
			{/if}

			{#if form?.canSave}
				<div class="card-actions justify-end">
					<button class="btn btn-success">Save</button>
				</div>
			{/if}
		</form>
	</div>
</div>
