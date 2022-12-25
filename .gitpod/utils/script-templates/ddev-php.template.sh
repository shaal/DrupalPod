#!/usr/bin/env bash
echo "Notice: running 'php $*' in ddev"
ddev exec_d php "$@"
