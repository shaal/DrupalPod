#!/usr/bin/env bash
echo "Notice: running 'drush $*' in ddev"
ddev exec_d drush "$@"
