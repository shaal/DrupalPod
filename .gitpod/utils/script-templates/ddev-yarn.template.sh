#!/usr/bin/env bash
echo "Notice: running 'yarn $*' in ddev"
/usr/local/bin/ddev exec_d yarn "$@"
