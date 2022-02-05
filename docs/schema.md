### objectives

Objectives are the data that describe something that needs to be completed.

- id
- label
- description
- 1\*\*n tags
- created_at
- updated_at

### completions

Completions are the state of a board that maintain what objectives have been completed

- id
- objective_id
- state -- enumeration [incomplete|complete|in progress]?
- notes -- user defined description
- created_at
- updated_at

### tags

- id
- label

### games

- id
- label
- description
- board_size
- 1\*\*n users -- the audience...those that can view or play the game. Consider that this association table may be where the user's role is defined.
- 1\*\*n boards -- A game owns its boards. When a game is deleted/expired it should delete the boards
- 1\*\*n objectives -- A game can have more objectives than board spaces to allow players to have different boards
- expires_at -- expiration indicates when a game is to be finished. There should probably be a one year limit on games. They can then be removed at some time + expires_at
- created_at
- updated_at

### boards

A board is an instance for a game. A user owns a board and has full permissions. Other users can read the board.

_board_

- id
- user_id -- owner
- created_at
- updated_at

_game_board_

- game_id
- board_id

_board_completions_

- completion_id
- board_id

### feeds

- id
- user_id
- message
- created_at
- updated_at

_feeds_games_

- game_id
- feed_id

A board has a randomly selected options from the category
