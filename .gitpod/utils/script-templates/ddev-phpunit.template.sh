#!/usr/bin/env bash
>&2 echo "Notice: running 'phpunit $*' in ddev"
ddev exec_d phpunit "$@"
