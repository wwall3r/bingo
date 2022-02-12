<script lang="ts">
	import '../app.css';
	import ThemeSwitcher from '$lib/theme/ThemeSwitcher.svelte';
	import { session } from '$app/stores';
	import { onMount } from 'svelte';
	import { themeChange } from 'theme-change';
	import { page } from '$app/stores';
	import { getRelativePath } from '$lib/auth/helper';

	// get relative URL for this page to redirect back to after logging in
	$: redirect = getRelativePath($page.url);

	onMount(async () => {
		themeChange(false);
	});
</script>

<svelte:head><title>Bingo!</title></svelte:head>

<div class="shadow drawer">
	<input id="menu-drawer" type="checkbox" class="drawer-toggle" />
	<div class="flex flex-col drawer-content min-h-screen">
		<nav class="w-full navbar bg-primary text-primary-content">
			<div class="flex-none md:hidden">
				<label for="menu-drawer" class="btn btn-square btn-ghost">
					<svg
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						class="inline-block w-6 h-6 stroke-current"
					>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M4 6h16M4 12h16M4 18h16"
						/>
					</svg>
				</label>
			</div>
			<div class="flex-1 px-2 mx-2">
				<a sveltekit:prefetch href="/" aria-label="home">Bingo!</a>
			</div>
			<div class="flex">
				<div class="flex-none hidden md:block">
					{#if $session.user}
						<a
							class="btn btn-ghost rounded-btn"
							sveltekit:prefetch
							href="/games"
							aria-label="My Games">Games</a
						>
					{:else}
						<a
							class="btn btn-ghost rounded-btn"
							aria-label="log in"
							sveltekit:prefetch
							href={`/auth/login?redirect=${encodeURIComponent(redirect)}`}>Log in</a
						>
						<a
							class="btn btn-ghost rounded-btn"
							aria-label="sign up"
							sveltekit:prefetch
							href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}>Sign up</a
						>
					{/if}
				</div>
				<ThemeSwitcher />
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
		<ul class="p-4 overflow-y-auto menu w-80 bg-base-100 text-base-content">
			{#if $session.user}
				<li>
					<a sveltekit:prefetch href="/games" aria-label="My Games">Games</a>
				</li>
			{:else}
				<li>
					<a
						aria-label="log in"
						sveltekit:prefetch
						href={`/auth/login?redirect=${encodeURIComponent(redirect)}`}>Log in</a
					>
				</li>
				<li>
					<a
						aria-label="sign up"
						sveltekit:prefetch
						href={`/auth/signup?redirect=${encodeURIComponent(redirect)}`}>Sign up</a
					>
				</li>
			{/if}
		</ul>
	</div>
</div>
