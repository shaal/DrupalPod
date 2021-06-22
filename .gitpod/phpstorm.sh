#!/bin/bash

if [ ! -x ~/.projector/configs/PhpStorm/run.sh ]; then
  echo "PhpStorm runner not found" && exit 1
fi
~/.projector/configs/PhpStorm/run.sh $GITPOD_REPO_ROOT