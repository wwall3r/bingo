import type { TypedSupabaseClient } from './utils';
import type { Database } from './types';

import wrap from './wrap';

const table = 'completions';

type CompletionUpdate = Database['public']['Tables']['completions']['Update'] & { id: string };

export default {
	async one(client: TypedSupabaseClient, id: string) {
		return wrap(
			client
				.from(table)
				.select(
					`
					id,
					notes,
					state,
					objectives (
						id,
						label,
						description
					)
				`
				)
				.eq('id', id)
				.single()
		);
	},
	async state(client: TypedSupabaseClient, id: string) {
		return wrap(client.from(table).select(`state`).eq('id', id).single());
	},
	async update(client: TypedSupabaseClient, completion: CompletionUpdate) {
		return wrap(client.from(table).update(completion).eq('id', completion.id));
	}
};
