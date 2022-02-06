export default ({ data, error }) => {
	if (error) {
		throw new Error(error.message);
	}

	return data;
};
