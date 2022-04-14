#!/usr/bin/env bash
echo "Notice: running 'node $*' in ddev"
/usr/local/bin/ddev exec_d node "$@"
