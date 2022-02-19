#!/usr/bin/env bash
if [ -n "$DEBUG_SCRIPT" ]; then
    set -x
fi

if [ ! -x ~/.projector/configs/PhpStorm/run.sh ]; then
  echo "PhpStorm runner not found" && exit 1
fi

# When port 9999 is ready - open that port in a new browser tab
gp await-port 9999 && gp preview "$(gp url 9999)" --external &

# Run PHPStorm
~/.projector/configs/PhpStorm/run.sh "$GITPOD_REPO_ROOT"
