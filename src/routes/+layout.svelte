<script lang="ts">
	import '../app.css';
	import MenuIcon from 'svelte-feather-icons/src/icons/MenuIcon.svelte';
	import LogInIcon from 'svelte-feather-icons/src/icons/LogInIcon.svelte';
	import LogOutIcon from 'svelte-feather-icons/src/icons/LogOutIcon.svelte';
	import ArrowUpIcon from 'svelte-feather-icons/src/icons/ArrowUpIcon.svelte';
	import { page } from '$app/stores';
	import { getRelativePath } from '$lib/auth/helper';

	// get relative URL for this page to redirect back to after logging in
	$: redirect = getRelativePath($page.url);

	let menuCheckbox: HTMLInputElement;

	const closeDrawer = () => {
		menuCheckbox.checked = false;
	};
</script>

<svelte:head><title>Bingo!</title></svelte:head>

<div class="shadow drawer">
	<input bind:this={menuCheckbox} id="menu-drawer" type="checkbox" class="drawer-toggle" />
	<div class="flex flex-col drawer-content min-h-screen">
		<nav class="w-full navbar bg-primary text-primary-content">
			<div class="flex-none md:hidden">
				<label for="menu-drawer" class="btn btn-square btn-ghost">
					<MenuIcon class="inline-block w-6 h-6 stroke-current" />
				</label>
			</div>
			<div class="flex-1 px-2 mx-2">
				<a data-sveltekit-prefetch href="/" aria-label="home">Bingo!</a>
			</div>
			<div class="flex items-center">
				<div class="flex-none hidden md:flex items-center">
					{#if $page.data.user}
						<a
							class="btn btn-ghost rounded-btn"
							data-sveltekit-prefetch
							href="/games"
							aria-label="Games"
						>
							Games
						</a>
						<a
							class="btn btn-ghost rounded-btn"
							aria-label="sign up"
							data-sveltekit-prefetch
							href={`/api/auth/logout?redirect=${encodeURIComponent(
								`/auth/login?redirect=${encodeURIComponent(redirect)}`
							)}`}
						>
							<LogOutIcon class="inline-block w-6 h-6 stroke-current mr-2" /> Log out
						</a>
					{:else}
						<a
							class="btn btn-ghost rounded-btn"
							aria-label="log in"
							data-sveltekit-prefetch
							href={`/auth/login?redirect=${encodeURIComponent(redirect)}`}
						>
							<LogInIcon class="inline-block w-6 h-6 stroke-current mr-2" /> Log in
						</a>
						<a
							class="btn btn-ghost rounded-btn"
							aria-label="sign up"
							data-sveltekit-prefetch
							href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}
						>
							<ArrowUpIcon class="inline-block w-6 h-6 stroke-current mr-2" /> Sign up
						</a>
					{/if}
				</div>
			</div>
		</nav>
		<main class="flex-1">
			<slot />
		</main>
		<footer class="p-4 footer footer-center bg-neutral text-neutral-content">
			<span class="text-x1"> Shout-outs and Copyright and such </span>
		</footer>
	</div>
	<div class="drawer-side">
		<label for="menu-drawer" class="drawer-overlay">Menu</label>
		<ul class="p-4 overflow-y-auto menu w-80 bg-base-100 text-base-content" on:click={closeDrawer}>
			{#if $page.data.user}
				<li>
					<a data-sveltekit-prefetch href="/games" aria-label="Games">Games</a>
				</li>
				<li>
					<a
						aria-label="sign up"
						data-sveltekit-prefetch
						href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}
					>
						<LogOutIcon class="inline-block w-6 h-6 stroke-current mr-2" /> Log out
					</a>
				</li>
			{:else}
				<li>
					<a
						aria-label="log in"
						data-sveltekit-prefetch
						href={`/auth/login?redirect=${encodeURIComponent(redirect)}`}
					>
						<LogInIcon class="inline-block w-6 h-6 stroke-current mr-2" /> Log in
					</a>
				</li>
				<li>
					<a
						aria-label="sign up"
						data-sveltekit-prefetch
						href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}
					>
						<ArrowUpIcon class="inline-block w-6 h-6 stroke-current mr-2" /> Sign up
					</a>
				</li>
			{/if}
		</ul>
	</div>
</div>
