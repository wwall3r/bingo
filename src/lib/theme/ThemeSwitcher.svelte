<script lang="ts">
	import ImageIcon from 'svelte-feather-icons/src/icons/ImageIcon.svelte';

	let themes: string[] = [
		'light',
		'dark',
		'cupcake',
		'bumblebee',
		'emerald',
		'corporate',
		'synthwave',
		'retro',
		'cyberpunk',
		'valentine',
		'halloween',
		'garden',
		'forest',
		'aqua',
		'lofi',
		'pastel',
		'fantasy',
		'wireframe',
		'black',
		'luxury',
		'dracula',
		'cmyk'
	];
</script>

<div class="dropdown dropdown-end">
	<div tabindex="0" class="btn btn-ghost">
		<ImageIcon class="inline-block w-6 h-6 stroke-current md:mr-2" />
		<span class="hidden md:block">Theme</span>
	</div>
	<ul
		tabindex="0"
		class="p-1 shadow menu compact dropdown-content bg-base-100 text-base-content w-52 h-[32rem] rounded-box overflow-y-auto"
	>
		{#each themes as theme}
			<li>
				<a tabindex="0" data-set-theme={theme.toLowerCase()} data-act-class="ACTIVECLASS">
					{theme}
				</a>
			</li>
		{/each}
	</ul>
</div>
