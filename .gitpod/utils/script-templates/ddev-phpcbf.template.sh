#!/usr/bin/env bash
>&2 echo "Notice: running 'phpcbf $*' in ddev"
ddev exec_d phpcbf "$@"
