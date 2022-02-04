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
  - consider security rammifications of revealing information)
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
1. `psql 'postgresql://postgres:postgres@localhost:54322/postgres' < supabase/seed_data/data.sql` load the seed data. Use [postgresql-client](https://www.postgresql.org/download/linux/ubuntu/)
1. `npm run dev` to start the application
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

```
pg_dump --data-only \
  --table public.objectives \
  --table public.games \
  --table public.tags \
  --table public.boards \
  --table public.completions \
  --table public.boards_completions \
  --table public.games_objectives \
  --table public.tags_objectives \
  --table auth.identities \
  --table auth.users \
'postgresql://postgres:postgres@localhost:54322/postgres' > supabase/seed_data/data.sql
```

# create-svelte

Everything you need to build a Svelte project, powered by [`create-svelte`](https://github.com/sveltejs/kit/tree/master/packages/create-svelte).

## Creating a project

If you're seeing this, you've probably already done this step. Congrats!

```bash
# create a new project in the current directory
npm init svelte@next

# create a new project in my-app
npm init svelte@next my-app
```

> Note: the `@next` is temporary

## Developing

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

> To deploy your app, you may need to install an [adapter](https://kit.svelte.dev/docs#adapters) for your target environment.
