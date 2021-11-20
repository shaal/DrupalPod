#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Remove access to user's Git credentials (restore by restart workspace)
git config --global --unset credential.helper
