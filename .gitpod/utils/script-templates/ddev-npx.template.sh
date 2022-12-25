#!/usr/bin/env bash
echo "Notice: running 'npx $*' in ddev"
ddev exec_d npx "$@"
