export default async <T>(cmd: PromiseLike<{ data: T; error: unknown }>): Promise<T> => {
	const { data, error } = await cmd;

	if (error) {
		throw error;
	}

	return data;
};
