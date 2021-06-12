#!/usr/bin/env bash

[ -z "$project_type" ] && echo "Project Type EMPTY"

if [ -z "$issue_fork" ]
then
      echo "\$issue_fork is empty"
else
      echo "\$issue_fork is NOT empty"
fi