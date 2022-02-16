#!/bin/bash
set -e

function usage {
  cat << EOF
Utility to save and load data for development purposes

Usage: ./data.sh COMMAND

COMMAND Options
1. 'load' - loads the data from supabase/seed_data/data.sql to the database
2. 'dump' - dumps the data from the database to supabase/seed_data/data.sql

EOF
}

function docker_postgres() {
  $(dirname $0)/postgres.sh "$@"
}

function load_data {
  docker_postgres psql -f supabase/seed_data/data.sql
}

function dump_data {
  docker_postgres \
    pg_dump --data-only \
    --table public.objectives \
    --table public.games \
    --table public.tags \
    --table public.boards \
    --table public.completion_states \
    --table public.completions \
    --table public.roles \
    --table public.user_profiles \
    --table public.boards_completions \
    --table public.games_boards \
    --table public.games_objectives \
    --table public.games_users \
    --table public.tags_objectives \
    --table auth.identities \
    --table auth.users \
  > supabase/seed_data/data.sql
}

# execute command
COMMAND=$1
if [ "load" = "$COMMAND" ] ; then
  load_data
elif [ "dump" = "$COMMAND" ] ; then
  dump_data
else
  usage
fi
