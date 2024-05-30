#!/usr/bin/env bash
>&2 echo "Notice: running 'node $*' in ddev"
ddev exec_d node "$@"
