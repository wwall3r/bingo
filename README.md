# Vision
The idea is to create multiple types of bingo games and share a game with individuals.

1. Different categories of bingo
  1. Enumerate all the different options in that category
  1. Generate a board from those options
1. Shared games ?
  1. Updates ?

# Roles
* anon: An unauthenticated user
* player: An authenticated user
* director: manages a game instance.
* admin: a bingo maintainer and administrator with full control of all APIs and data

# Use Cases

## anon
* Visit the site and see options/overview
* Signup / Signin

## admin
* can disable players
* can approve/CRUD a category
* can approve/CRUD objectives to a category

## director
* creates a game instance
* selects a board size
* selects the category and filters objectives appropriate for the game instance
* invites players or anonymous
  * This may be a backend workflow which doesn't care. It either adds an existing player or sends an invitation
  * consider security rammifications of revealing information)
  * can find players or do they have to know e-mail addresses?
* can view all board instances for their game instances
* can promote players to directors for a game instance

## players
* have an alias / profile
* view their board instances
* send a link to their board
* view others boards in a game instance
* see updates to the game feed (assume no secret states)
* proposes categories and objectives 
* update their board with a 'completion' of an objective
* list games they are members of

# Concepts
1. Categories are just tags on objectives. This allow reuse of objectives.

# Goals
1. Write an example that exercises the features in supabase.io

# Tasks/Next Steps

# Questions
1. How are migrations handled?
2. How are updates shared? A restart of a local development instance had all the data go away.
3. Native psql connection? This is listed in the docs.


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
