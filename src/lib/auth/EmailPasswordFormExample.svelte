<script>
	import SlashIcon from 'svelte-feather-icons/src/icons/SlashIcon.svelte';
	import { page } from '$app/stores';

	export let action = '/api/login';

	$: redirect = $page.url.searchParams.get('redirect') || '';
	$: error = $page.url.searchParams.get('error') || '';
</script>

<div class="m-2 p-2 card card-compact card-bordered md:card-normal md:max-w-md md:mx-auto">
	<div class="card-body">
		<form {action} method="post">
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
					class:input-error={error}
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
					class:input-error={error}
					required
				/>
			</div>

			{#if error}
				<div class="alert alert-error mt-2">
					<span> <SlashIcon class="inline-block w-6 h-6 stroke-current mr-2" />{error}</span>
				</div>
			{/if}

			<div class="card-actions justify-end">
				<slot {redirect} />
			</div>
		</form>
	</div>
</div>
