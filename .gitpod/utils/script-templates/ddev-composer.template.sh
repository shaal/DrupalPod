#!/usr/bin/env bash
echo "Notice: running 'composer $*' in ddev"
ddev exec_d composer "$@"
