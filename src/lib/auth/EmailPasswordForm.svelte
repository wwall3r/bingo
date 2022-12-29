<script lang="ts">
	import SlashIcon from 'svelte-feather-icons/src/icons/SlashIcon.svelte';
	import { enhance } from '$app/forms';
	import { page } from '$app/stores';

	interface Form {
		error?: string;
		values?: {
			email: string;
		};
	}

	export let form: Form | null;

	$: redirect = $page.url.searchParams.get('redirect') || '';
</script>

<div class="m-2 p-2 card card-compact card-bordered md:card-normal md:max-w-md md:mx-auto">
	<div class="card-body">
		<form method="post" use:enhance>
			<input name="redirect" type="hidden" value={redirect} />
			<div class="form-control">
				<label for="email" class="label">
					<span class="label-text">E-mail</span>
				</label>
				<input
					name="email"
					type="email"
					aria-label="e-mail"
					class="input input-bordered"
					class:input-error={form?.error}
					value={form?.values?.email ?? ''}
					required
				/>
			</div>
			<div class="form-control">
				<label for="password" class="label">
					<span class="label-text">Password</span>
				</label>
				<input
					name="password"
					type="password"
					aria-label="password"
					class="input input-bordered"
					class:input-error={form?.error}
					required
				/>
			</div>

			{#if form?.error}
				<div class="alert alert-error mt-2">
					<span> <SlashIcon class="inline-block w-6 h-6 stroke-current mr-2" />{form.error}</span>
				</div>
			{/if}

			<div class="card-actions justify-end">
				<slot {redirect} />
			</div>
		</form>
	</div>
</div>
