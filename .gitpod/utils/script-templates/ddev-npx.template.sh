#!/usr/bin/env bash
echo "Notice: running 'npx $*' in ddev"
/usr/local/bin/ddev exec_d npx "$@"
