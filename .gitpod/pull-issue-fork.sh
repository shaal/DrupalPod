#!/usr/bin/env bash
set -x

# Type (core/module/theme) 
# Drupal core version
# Module version
# Issue fork to work on

if [ "$project_type" != "core" ] && ["$project_type" != "module" ] && [ "$project_type" != "theme" ]; then 
      project_type="core"
fi

if [ -z "$core_version" ]; then
      core_version="9.2.x"
fi

if [ -z "$issue_fork" ]
then
      echo "\$issue_fork is empty"
else
      echo "\$issue_fork is NOT empty"
fi

cd repos/Drupal
git checkout $core_version
ddev composer update
