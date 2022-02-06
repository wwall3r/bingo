import supabase from '../db';
import wrap from './wrap';
import type { definitions } from './types';

const table = 'objectives';

export type Objective = definitions['objectives'];

export default {
	async all(): Promise<Objective[]> {
		return wrap(await supabase.from(table).select());
	},

	async insert(objectives: Objective | Objective[]): Promise<any> {
		return wrap(
			await supabase.from(table).insert(Array.isArray(objectives) ? objectives : [objectives])
		);
	}
};
