#!/usr/bin/env bash
>&2 echo "Notice: running 'npx $*' in ddev"
ddev exec_d npx "$@"
