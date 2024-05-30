#!/usr/bin/env bash
>&2 echo "Notice: running 'composer $*' in ddev"
ddev exec_d composer "$@"
