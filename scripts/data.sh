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

function absolute_path_of_file() {
	local SOURCE=$0
  local CWD DIR
	CWD=$(pwd)
	while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
		DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
		SOURCE=$(readlink "$SOURCE")
		[[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
	done
	DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
	cd "$CWD"
	echo "$DIR"
}

function load_data() {
  docker run -it --rm --net host --env-file "${ENV_FILE}" -v "${PROJECT_DIR}":/workspace -w /workspace supabase/postgres:14.1.0 psql -f supabase/seed_data/data.sql
}

function dump_data() {
  docker run -it --rm --net host --env-file "${ENV_FILE}" -v "${PROJECT_DIR}":/workspace -w /workspace supabase/postgres:14.1.0 \
    pg_dump --data-only \
    --table public.objectives \
    --table public.games \
    --table public.tags \
    --table public.boards \
    --table public.completions \
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

START_DIR=$(pwd)
SCRIPTS_DIR=$(absolute_path_of_file "${BASH_SOURCE[0]}")
cd "$SCRIPTS_DIR"
cd ..
PROJECT_DIR=$(pwd)
ENV_FILE="${PROJECT_DIR}/.env"

# Check for prerequistes
if [ ! -f "${ENV_FILE}" ]; then
    echo "Environment file ${ENV_FILE} does not exist!"
	exit 1
fi

# execute command
COMMAND=$1
if [ "load" = "$COMMAND" ] ; then
  load_data
elif [ "dump" = "$COMMAND" ] ; then
  dump_data
else
  usage
fi


cd "$START_DIR"