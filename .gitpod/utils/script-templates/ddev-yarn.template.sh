#!/usr/bin/env bash
echo "Notice: running 'yarn $*' in ddev"
ddev exec_d yarn "$@"
