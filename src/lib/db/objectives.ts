import supabase from '../db';
import wrap from './wrap';
import Operators from './operators';
import type { definitions } from './types';

const table = 'objectives';

export type Objective = definitions['objectives'];

export default {
	async all(): Promise<Objective[]> {
		return wrap(() => supabase.from(table).select());
	},

	async insert(objectives: Objective | Objective[]): Promise<any> {
		return wrap(() =>
			supabase.from(table).insert(Array.isArray(objectives) ? objectives : [objectives])
		);
	},

	async search(terms: string, operator: Operators = Operators.AND): Promise<Objective[]> {
		const query = terms
			.split(/\s+/)
			.map((t) => `'${t}'`)
			.join(` ${operator} `);

		// TODO: add full text index for label + description
		return wrap(() =>
			supabase
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
		);
	}
};
