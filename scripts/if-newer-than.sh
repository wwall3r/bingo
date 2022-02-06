#!/usr/bin/env bash

function usage {
  echo 'Whether or not file/dir x is newer than file/dir y'
  echo 'example: ./if-newer-than.sh <x> <y>'
}

if [ -z "$2" ]; then
  usage
fi

function latest {
  find "$1" -printf '%T@\n' | sort -n | tail -1
}

time1=$(latest "$1")
time2=$(latest "$2")

# bc uses true=1, false=0;
# bash return codes are the opposite
if (( $(echo "$time1 > $time2" | bc) )); then
  exit 0;
else
  exit 1;
fi
