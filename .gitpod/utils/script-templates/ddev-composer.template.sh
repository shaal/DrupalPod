#!/usr/bin/env bash
echo "Notice: running 'composer $*' in ddev"
/usr/local/bin/ddev exec_d composer "$@"
