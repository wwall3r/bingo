const config = {
	mode: 'jit',
	content: ['./src/**/*.{html,js,svelte,ts}'],

	theme: {
		extend: {
			keyframes: {
				wiggle: {
					'0%, 100%': { transform: 'rotate(-3deg)' },
					'50%': { transform: 'rotate(3deg)' }
				}
			},

			animation: {
				wiggle: 'wiggle 1s ease-in-out infinite'
			}
		}
	},

	plugins: [require('@tailwindcss/typography'), require('daisyui')],

	daisyui: {
		themes: ['light', 'dark']
	}
};

module.exports = config;
