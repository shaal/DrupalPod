#!/usr/bin/env bash
echo "Notice: running 'nvm $*' in ddev"
ddev exec_d nvm "$@"
