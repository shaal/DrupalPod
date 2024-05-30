#!/usr/bin/env bash
>&2 echo "Notice: running 'phpcs $*' in ddev"

if [ -n "${GITPOD_REPO_ROOT:-}" ]; then
  # Replace all references to the absolute paths to the repo root.
  # This will ensure IDEs like PHPStorm can pass files into it without issue.
  arguments=()
  for arg in "$@"; do
    new_arg="${arg//${GITPOD_REPO_ROOT}//var/www/html}"
    arguments+=("$new_arg")
  done
else
  arguments=("$@")
fi

ddev exec_d phpcs "${arguments[@]}"
