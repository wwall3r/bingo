export type Json = string | number | boolean | null | { [key: string]: Json } | Json[];

export interface Database {
	public: {
		Tables: {
			cards: {
				Row: {
					created_at: string;
					id: string;
					updated_at: string;
					user_id: string;
				};
				Insert: {
					created_at?: string;
					id?: string;
					updated_at?: string;
					user_id: string;
				};
				Update: {
					created_at?: string;
					id?: string;
					updated_at?: string;
					user_id?: string;
				};
			};
			cards_completions: {
				Row: {
					card_id: string;
					completion_id: string;
				};
				Insert: {
					card_id: string;
					completion_id: string;
				};
				Update: {
					card_id?: string;
					completion_id?: string;
				};
			};
			completion_states: {
				Row: {
					created_at: string | null;
					id: number;
					label: string;
					updated_at: string | null;
				};
				Insert: {
					created_at?: string | null;
					id?: number;
					label: string;
					updated_at?: string | null;
				};
				Update: {
					created_at?: string | null;
					id?: number;
					label?: string;
					updated_at?: string | null;
				};
			};
			completions: {
				Row: {
					created_at: string;
					id: string;
					notes: string | null;
					objective_id: string;
					state: number | null;
					updated_at: string;
				};
				Insert: {
					created_at?: string;
					id?: string;
					notes?: string | null;
					objective_id: string;
					state?: number | null;
					updated_at?: string;
				};
				Update: {
					created_at?: string;
					id?: string;
					notes?: string | null;
					objective_id?: string;
					state?: number | null;
					updated_at?: string;
				};
			};
			games: {
				Row: {
					card_size: number;
					created_at: string | null;
					description: string | null;
					expires_at: string | null;
					id: string;
					label: string;
					updated_at: string | null;
				};
				Insert: {
					card_size?: number;
					created_at?: string | null;
					description?: string | null;
					expires_at?: string | null;
					id?: string;
					label: string;
					updated_at?: string | null;
				};
				Update: {
					card_size?: number;
					created_at?: string | null;
					description?: string | null;
					expires_at?: string | null;
					id?: string;
					label?: string;
					updated_at?: string | null;
				};
			};
			games_cards: {
				Row: {
					card_id: string;
					game_id: string;
				};
				Insert: {
					card_id: string;
					game_id: string;
				};
				Update: {
					card_id?: string;
					game_id?: string;
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
					role_id: string;
					user_id: string | null;
				};
				Insert: {
					game_id: string;
					role_id?: string;
					user_id?: string | null;
				};
				Update: {
					game_id?: string;
					role_id?: string;
					user_id?: string | null;
				};
			};
			objectives: {
				Row: {
					created_at: string | null;
					description: string | null;
					id: string;
					label: string;
					updated_at: string;
				};
				Insert: {
					created_at?: string | null;
					description?: string | null;
					id?: string;
					label: string;
					updated_at?: string;
				};
				Update: {
					created_at?: string | null;
					description?: string | null;
					id?: string;
					label?: string;
					updated_at?: string;
				};
			};
			roles: {
				Row: {
					created_at: string | null;
					description: string | null;
					id: string;
					label: string;
				};
				Insert: {
					created_at?: string | null;
					description?: string | null;
					id?: string;
					label: string;
				};
				Update: {
					created_at?: string | null;
					description?: string | null;
					id?: string;
					label?: string;
				};
			};
			tags: {
				Row: {
					created_at: string | null;
					id: string;
					label: string;
					updated_at: string | null;
				};
				Insert: {
					created_at?: string | null;
					id?: string;
					label: string;
					updated_at?: string | null;
				};
				Update: {
					created_at?: string | null;
					id?: string;
					label?: string;
					updated_at?: string | null;
				};
			};
			tags_objectives: {
				Row: {
					objective_id: string;
					tag_id: string;
				};
				Insert: {
					objective_id: string;
					tag_id: string;
				};
				Update: {
					objective_id?: string;
					tag_id?: string;
				};
			};
			user_profiles: {
				Row: {
					created_at: string;
					display_name: string | null;
					id: string;
					role_id: string;
					updated_at: string;
				};
				Insert: {
					created_at?: string;
					display_name?: string | null;
					id: string;
					role_id?: string;
					updated_at?: string;
				};
				Update: {
					created_at?: string;
					display_name?: string | null;
					id?: string;
					role_id?: string;
					updated_at?: string;
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
			create_card: {
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
					card_id: string;
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
