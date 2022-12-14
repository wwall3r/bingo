export type Json = string | number | boolean | null | { [key: string]: Json } | Json[];

export interface Database {
	public: {
		Tables: {
			boards: {
				Row: {
					user_id: string;
					id: string;
					created_at: string;
					updated_at: string;
				};
				Insert: {
					user_id: string;
					id?: string;
					created_at?: string;
					updated_at?: string;
				};
				Update: {
					user_id?: string;
					id?: string;
					created_at?: string;
					updated_at?: string;
				};
			};
			boards_completions: {
				Row: {
					board_id: string;
					completion_id: string;
				};
				Insert: {
					board_id: string;
					completion_id: string;
				};
				Update: {
					board_id?: string;
					completion_id?: string;
				};
			};
			completion_states: {
				Row: {
					id: number;
					label: string;
					created_at: string | null;
					updated_at: string | null;
				};
				Insert: {
					id?: number;
					label: string;
					created_at?: string | null;
					updated_at?: string | null;
				};
				Update: {
					id?: number;
					label?: string;
					created_at?: string | null;
					updated_at?: string | null;
				};
			};
			completions: {
				Row: {
					objective_id: string;
					notes: string | null;
					id: string;
					created_at: string;
					updated_at: string;
					state: number | null;
				};
				Insert: {
					objective_id: string;
					notes?: string | null;
					id?: string;
					created_at?: string;
					updated_at?: string;
					state?: number | null;
				};
				Update: {
					objective_id?: string;
					notes?: string | null;
					id?: string;
					created_at?: string;
					updated_at?: string;
					state?: number | null;
				};
			};
			games: {
				Row: {
					label: string;
					description: string | null;
					id: string;
					board_size: number;
					created_at: string | null;
					updated_at: string | null;
					expires_at: string | null;
				};
				Insert: {
					label: string;
					description?: string | null;
					id?: string;
					board_size?: number;
					created_at?: string | null;
					updated_at?: string | null;
					expires_at?: string | null;
				};
				Update: {
					label?: string;
					description?: string | null;
					id?: string;
					board_size?: number;
					created_at?: string | null;
					updated_at?: string | null;
					expires_at?: string | null;
				};
			};
			games_boards: {
				Row: {
					game_id: string;
					board_id: string;
				};
				Insert: {
					game_id: string;
					board_id: string;
				};
				Update: {
					game_id?: string;
					board_id?: string;
				};
			};
			games_objectives: {
				Row: {
					game_id: string;
					objective_id: string;
				};
				Insert: {
					game_id: string;
					objective_id: string;
				};
				Update: {
					game_id?: string;
					objective_id?: string;
				};
			};
			games_users: {
				Row: {
					game_id: string;
					user_id: string | null;
					role_id: string;
				};
				Insert: {
					game_id: string;
					user_id?: string | null;
					role_id?: string;
				};
				Update: {
					game_id?: string;
					user_id?: string | null;
					role_id?: string;
				};
			};
			objectives: {
				Row: {
					label: string;
					description: string | null;
					id: string;
					created_at: string | null;
					updated_at: string;
				};
				Insert: {
					label: string;
					description?: string | null;
					id?: string;
					created_at?: string | null;
					updated_at?: string;
				};
				Update: {
					label?: string;
					description?: string | null;
					id?: string;
					created_at?: string | null;
					updated_at?: string;
				};
			};
			roles: {
				Row: {
					label: string;
					description: string | null;
					id: string;
					created_at: string | null;
				};
				Insert: {
					label: string;
					description?: string | null;
					id?: string;
					created_at?: string | null;
				};
				Update: {
					label?: string;
					description?: string | null;
					id?: string;
					created_at?: string | null;
				};
			};
			tags: {
				Row: {
					label: string;
					id: string;
					created_at: string | null;
					updated_at: string | null;
				};
				Insert: {
					label: string;
					id?: string;
					created_at?: string | null;
					updated_at?: string | null;
				};
				Update: {
					label?: string;
					id?: string;
					created_at?: string | null;
					updated_at?: string | null;
				};
			};
			tags_objectives: {
				Row: {
					tag_id: string;
					objective_id: string;
				};
				Insert: {
					tag_id: string;
					objective_id: string;
				};
				Update: {
					tag_id?: string;
					objective_id?: string;
				};
			};
			user_profiles: {
				Row: {
					id: string;
					display_name: string | null;
					created_at: string;
					updated_at: string;
					role_id: string;
				};
				Insert: {
					id: string;
					display_name?: string | null;
					created_at?: string;
					updated_at?: string;
					role_id?: string;
				};
				Update: {
					id?: string;
					display_name?: string | null;
					created_at?: string;
					updated_at?: string;
					role_id?: string;
				};
			};
		};
		Views: {
			[_ in never]: never;
		};
		Functions: {
			can_write_completions: {
				Args: { p_user_id: string };
				Returns: boolean;
			};
			create_board: {
				Args: { p_game_id: string; p_user_id: string; p_num_objectives: number };
				Returns: undefined;
			};
			default_game_role: {
				Args: Record<PropertyKey, never>;
				Returns: string;
			};
			default_system_role: {
				Args: Record<PropertyKey, never>;
				Returns: string;
			};
			get_completions_for_user: {
				Args: Record<PropertyKey, never>;
				Returns: {
					board_id: string;
					game_id: string;
					user_id: string;
					completion_id: string;
				}[];
			};
			get_user_games: {
				Args: Record<PropertyKey, never>;
				Returns: string[];
			};
			is_member_of: {
				Args: { _game_id: string };
				Returns: boolean;
			};
			system_role_id: {
				Args: Record<PropertyKey, never>;
				Returns: string;
			};
		};
		Enums: {
			[_ in never]: never;
		};
	};
}
