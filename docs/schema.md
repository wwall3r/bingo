### objectives
* id
* label
* description
* 1**n tags
* created_date
* updated_date

### tags
* id
* label

### games
* id
* label
* description
* board_size
* 1**n users
* 1**n boards
* 1**n objectives
* 1**n feed
* expiration_date
* created_date
* updated_date

### boards
* id
* user_id
* game_id
* 1**objectives
* completed_date
* created_date
* updated_date


A board has a randomly selected options from the category
