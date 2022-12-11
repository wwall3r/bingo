# For Jason (ditch this section after you've updated):

1. Ensure supabase is stopped
1. Upgrade supabase cli to latest: probably via `brew upgrade`
1. supabase start
1. Update `.env` with the keys from the output of `supabase start`
1. `./scripts/data.sh load`
1. Update node to latest lts: `nvm install --lts`
1. `corepack enable` (enable `pnpm` and `yarn` binaries delivered with node)
1. `pnpm i`
1. `pnpm dev`

# Vision

The idea is to create multiple types of bingo games and share a game with individuals.

1. Different categories of bingo
1. Enumerate all the different options in that category
1. Generate a board from those options
1. Shared games ?
1. Updates ?

# Roles

- anon: An unauthenticated user
- player: An authenticated user
- director: manages a game instance.
- admin: a bingo maintainer and administrator with full control of all APIs and data

# Use Cases

## anon

- Visit the site and see options/overview
- Signup / Signin

## admin

- can disable players
- can approve/CRUD a category
- can approve/CRUD objectives to a category

## director

- creates a game instance
- selects a board size
- selects the category and filters objectives appropriate for the game instance
- invites players or anonymous
  - This may be a backend workflow which doesn't care. It either adds an existing player or sends an invitation
  - consider security ramifications of revealing information)
  - can find players or do they have to know e-mail addresses?
- can view all board instances for their game instances
- can promote players to directors for a game instance

## players

- have an alias / profile
- view their board instances
- send a link to their board
- view others boards in a game instance
- see updates to the game feed (assume no secret states)
- proposes categories and objectives
- update their board with a 'completion' of an objective
- list games they are members of

# Concepts

1. Categories are just tags on objectives. This allow reuse of objectives.

# Goals

1. Write an example that exercises the features in supabase.io

# Tasks/Next Steps

- [ ] Login: CSRF handling
- [ ] Login: Progressive enhancement
- [ ] Logout

# Questions

1. How are migrations handled? The migrations are created by making changes to the database and running `supabase db commit` which will create a new sql file in the migrations folder.
2. How are updates shared? A restart of a local development instance had all the data go away. A seed data script was created to recreate data for testing. It can be run applying the sql.
3. Native psql connection? This is listed in the docs.

# Starting the application

1. `supabase start` start the database
1. `supabase db reset` recreates the database
1. `scripts/data.sh load` loads the seed data. Requires PGHOST, PGPORT, PGDATABASE, PGUSER, PGPASSWORD in .env
   1. Alternatively: `psql 'postgresql://postgres:postgres@localhost:54322/postgres' < supabase/seed_data/data.sql` load the seed data. Use [postgresql-client](https://www.postgresql.org/download/linux/ubuntu/)
1. `pnpm dev` to start the application
1. Test users - Password is `password`
   1. admin@email.com
   1. joe@email.com
   1. jane@email.com

## local developer locations

1. [supabase](http://localhost:54323/project/default)
1. [app](http://localhost:3000)

# Database

## navigation

- `\?` : help
- `\dt` : list tables, views, sequences
- `SET search_path TO auth;` : set schema to auth
- `\dn` : list schemas

## databackup

- Commit the changes `supabase db commit 'migration_name'`
- Dump the data `scripts/data.sh dump`
