import { error } from '@sveltejs/kit';
import Objectives from '$lib/db/objectives';

/** @type {import ('./$types').PageLoad} */
export async function load() {
	try {
		return await Objectives.all();
	} catch (e) {
		console.error(e);
	}

	throw error(404, 'objectives not found');
}
