#!/usr/bin/env bash
if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Preview port 8080
gp preview "$(gp url 8080)"
