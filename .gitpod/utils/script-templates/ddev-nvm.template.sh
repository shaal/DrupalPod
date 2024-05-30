#!/usr/bin/env bash
>&2 echo "Notice: running 'nvm $*' in ddev"
ddev exec_d nvm "$@"
