#!/usr/bin/env node
import { createClient } from '@supabase/supabase-js';
import readline from 'readline';

let SERVICE_KEY = '';

const rl = readline.createInterface({
	input: process.stdin,
	output: process.stdout
});

rl.question('What is your supabase service_role key? ', async (key) => {
	const supabase = createClient('http://localhost:54321', key);

	const { user, session, error } = await supabase.auth.signIn({
		email: 'will@email.com',
		password: 'password'
	});

	console.log(user, session, error);
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
