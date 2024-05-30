#!/usr/bin/env bash
>&2 echo "Notice: running 'phpcs $*' in ddev"
ddev exec_d phpcs "$@"
