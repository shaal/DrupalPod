#!/usr/bin/env bash
echo "Notice: running 'node $*' in ddev"
ddev exec_d node "$@"
