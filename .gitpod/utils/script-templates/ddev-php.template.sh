#!/usr/bin/env bash
>&2 echo "Notice: running 'php $*' in ddev"
ddev exec_d php "$@"
