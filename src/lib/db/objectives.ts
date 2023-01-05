import Operators from './operators';
import type { TypedSupabaseClient } from './utils';
import type { Database } from './types';
import wrap from './wrap';

const table = 'objectives';

type ObjectiveInsert = Database['public']['Tables']['objectives']['Insert'];

export default {
	async all(client: TypedSupabaseClient) {
		return wrap(client.from(table).select());
	},

	async insert(client: TypedSupabaseClient, objectives: ObjectiveInsert | ObjectiveInsert[]) {
		return wrap(client.from(table).insert(Array.isArray(objectives) ? objectives : [objectives]));
	},

	async search(client: TypedSupabaseClient, terms: string, operator: Operators = Operators.AND) {
		const query = terms
			.split(/\s+/)
			.map((t) => `'${t}'`)
			.join(` ${operator} `);

		// TODO: add full text index for label + description
		return wrap(
			client
				.from(table)
				.select(
					`
				id,
				label,
				description,
				tags (
					id,
					label
				)
			`
				)
				.textSearch('label', query)
				.returns<{
					id: string;
					label: string;
					description?: string;
					tags: {
						id: string;
						label: string;
					}[];
				}>()
		);
	}
};
