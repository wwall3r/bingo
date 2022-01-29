# Vision
The idea is to create multiple types of bingo games and share a game with individuals.

1. Different categories of bingo
  1. Enumerate all the different options in that category
  1. Generate a board from those options
1. Shared games ?
  1. Updates ?

# Use Cases
* Anonymous: Visit the site and see options/overview
* Anonymous: Signup / Signin

* A user can update their board with a 'completion'
* A user can have an alias / profile
* A user can list games they are members of

* A board has a randomly selected options from the category

* The admin, selects a board size
* The admin, invites anonymous (not registered users)
  * This may be a backend workflow which doesn't care. It either adds an existing user or sends an invitation
* The admin, adds players (consider security rammifications of revealing information)
* The admin can view all boards
* The admin can find users or do they have to know e-mail addresses?

* Players can view their board
* Players can send a link to their board
* Players can view others boards?
* Players can see updates to the game feed (assume no secret states)


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
