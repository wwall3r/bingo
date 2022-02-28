import supabase from '../db';
import wrap from './wrap';
import Operators from './operators';
import type { definitions } from './types';

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
	async all(): Promise<Objective[]> {
		return wrap(() => supabase.from<Objective>(table).select());
	},

	// TODO: This probably needs to be more specific than Partial;
	// e.g. a type with some fields required but others optional
	async insert(objectives: Partial<Objective> | Partial<Objective>[]): Promise<any> {
		return wrap(() =>
			supabase.from(table).insert(Array.isArray(objectives) ? objectives : [objectives])
		);
	},

	async search(terms: string, operator: Operators = Operators.AND): Promise<ObjectiveWithTags[]> {
		const query = terms
			.split(/\s+/)
			.map((t) => `'${t}'`)
			.join(` ${operator} `);

		// TODO: add full text index for label + description
		return wrap(() =>
			supabase
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
