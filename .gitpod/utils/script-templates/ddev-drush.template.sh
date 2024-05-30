#!/usr/bin/env bash
>&2 echo "Notice: running 'drush $*' in ddev"
ddev exec_d drush "$@"
