objective
  uuid
  display_name
  description
  1**n tags
  created_date
  updated_date

game_instance
  uuid
  display_name
  description
  board_size
  1**n directors_player_uuid
  1**n board_instances
  1**n objectives
  1**n game_feed
  expiration_date
  completed_date
  created_date
  updated_date
  
board_instance
  uuid
  uuid_player
  uuid_game_instance
  1**objectives
  created_date
  updated_date

profile
  uuid
  display_name
  description
  avatar
  created_date
  updated_date





A board has a randomly selected options from the category
