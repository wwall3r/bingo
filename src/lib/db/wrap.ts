import type PostgrestFilterBuilder from '@supabase/postgrest-js';

export default async <T>(cmd: () => PostgrestFilterBuilder<T>): Promise<T> => {
	const { data, error } = await cmd;

	if (error) {
		throw error;
	}

	return data;
};
