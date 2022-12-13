import Operators from './operators';
import type { TypedSupabaseClient } from '@supabase/auth-helpers-sveltekit';
import type { definitions } from './types';
import wrap from './wrap';

const table = 'objectives';

export type Objective = definitions['objectives'];
type Tag = {
	id: definitions['tags']['id'];
	label: definitions['tags']['label'];
};

export interface ObjectiveWithTags extends Objective {
	tags: Tag[];
}

export default {
	async all(client: TypedSupabaseClient): Promise<Objective[]> {
		return wrap(client.from<Objective>(table).select());
	},

	// TODO: This probably needs to be more specific than Partial;
	// e.g. a type with some fields required but others optional
	async insert(
		client: TypedSupabaseClient,
		objectives: Partial<Objective> | Partial<Objective>[]
	): Promise<any> {
		return wrap(client.from(table).insert(Array.isArray(objectives) ? objectives : [objectives]));
	},

	async search(
		client: TypedSupabaseClient,
		terms: string,
		operator: Operators = Operators.AND
	): Promise<ObjectiveWithTags[]> {
		const query = terms
			.split(/\s+/)
			.map((t) => `'${t}'`)
			.join(` ${operator} `);

		// TODO: add full text index for label + description
		return wrap(
			client
				.from<ObjectiveWithTags>(table)
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
		);
	}
};
