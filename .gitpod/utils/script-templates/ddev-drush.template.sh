#!/usr/bin/env bash
echo "Notice: running 'drush $*' in ddev"
/usr/local/bin/ddev exec_d drush "$@"
