export const scaledContent = (node) => {
	const scaledContent = node.querySelector('.scaled-content');
	scaledContent.style.transform = 'scale(1, 1)';

	const { width: contentWidth, height: contentHeight } = scaledContent.getBoundingClientRect();
	const { width: wrapperWidth, height: wrapperHeight } = node.getBoundingClientRect();

	const scaleAmountX = Math.min(
		(0.95 * wrapperWidth) / contentWidth,
		wrapperHeight / contentHeight
	);
	const scaleAmountY = scaleAmountX;

	if (scaleAmountX < 1) {
		scaledContent.style.transform = `scale(${scaleAmountX}, ${scaleAmountY})`;
	}

	scaledContent.style.visibility = 'visible';

	return {
		destroy() {}
	};
};
