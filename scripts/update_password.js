#!/usr/bin/env node
import { createClient } from '@supabase/supabase-js';
import readline from 'readline';

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});

rl.question('What is your supabase anon key? ', async (key) => {
	const supabase = createClient('http://localhost:54321', key);

	// log in
	console.log(
		await supabase.auth.signInWithPassword({
			email: 'will@email.com',
			password: 'password'
		})
	);

	// did we actually log in?
	console.log(await supabase.auth.getSession());

	// // check auth status
	// const { data, error: e3 } = await supabase.rpc('get_uid');
	// console.log(data, e3);

	// // pull record
	// const {data
	// console.log(await supabase.from('games').select());

	rl.close();

	// rl.question('Enter the user id: ', async (id) => {
	// 	rl.question('Enter the new password: ', async (password) => {
	// 		const { error } = await supabase.auth.api.updateUserById(id, { password });

	// 		if (error) {
	// 			console.log(error);
	// 		} else {
	// 			console.log('Password successfully changed.');
	// 		}

	// 		rl.close();
	// 	});
	// });
});
