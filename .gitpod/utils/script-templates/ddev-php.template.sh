#!/usr/bin/env bash
echo "Notice: running 'php $*' in ddev"
/usr/local/bin/ddev exec_d php "$@"
