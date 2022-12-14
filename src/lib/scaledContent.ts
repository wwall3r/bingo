export const scaledContent = (node: HTMLElement) => {
	const listener = () => {
		const scaledEl: HTMLElement | null = node.querySelector('.scaled-content');

		if (scaledEl) {
			scaledEl.style.transform = 'scale(1, 1)';

			const { width: contentWidth, height: contentHeight } = scaledEl.getBoundingClientRect();
			const { width: wrapperWidth, height: wrapperHeight } = node.getBoundingClientRect();

			const scaleAmountX = Math.min(
				(0.95 * wrapperWidth) / contentWidth,
				wrapperHeight / contentHeight
			);
			const scaleAmountY = scaleAmountX;

			if (scaleAmountX < 1) {
				scaledEl.style.transform = `scale(${scaleAmountX}, ${scaleAmountY})`;
			}

			scaledEl.style.visibility = 'visible';
		}
	};

	window.addEventListener('resize', listener);
	listener();

	return {
		destroy() {
			window.removeEventListener('resize', listener);
		}
	};
};
