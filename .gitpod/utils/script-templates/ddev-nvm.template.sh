#!/usr/bin/env bash
echo "Notice: running 'nvm $*' in ddev"
/usr/local/bin/ddev exec_d nvm "$@"
