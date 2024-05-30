#!/usr/bin/env bash
>&2 echo "Notice: running 'yarn $*' in ddev"
ddev exec_d yarn "$@"
