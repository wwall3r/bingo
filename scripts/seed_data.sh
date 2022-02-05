#!/bin/bash
set -e

function absolute_path_of_file() {
	local SOURCE=$0
  	local CWD,DIR
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

docker run -it --rm --net host --env-file "${ENV_FILE}" -v "${PROJECT_DIR}":/workspace -w /workspace supabase/postgres:14.1.0 psql -f supabase/seed_data/data.sql
cd "$START_DIR"