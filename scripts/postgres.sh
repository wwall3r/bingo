#!/usr/bin/env bash
set -e

function usage {
  echo "Runs postgres via docker."
  echo "example: ./postgres.sh psql ..."
}

SCRIPTS_DIR=$(dirname $0)
PROJECT_DIR=$(realpath "$SCRIPTS_DIR/../")
ENV_FILE="$PROJECT_DIR/.env"

# Check for prerequistes
if [ ! -f "$ENV_FILE" ]; then
  echo "Environment file $ENV_FILE does not exist!"
	exit 1
fi

if [ -z "$1" ]; then
  usage
fi

docker run -it --rm \
  --net host \
  --env-file "$ENV_FILE" \
  -v "$PROJECT_DIR":/workspace \
  -w /workspace \
  supabase/postgres:14.1.0 \
  "$@"
