#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (C) 2024 DevPanel
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation version 3 of the
# License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# For GNU Affero General Public License see <https://www.gnu.org/licenses/>.
# ----------------------------------------------------------------------

echo -e "-------------------------------"
echo -e "| DevPanel Quickstart Creator |"
echo -e "-------------------------------\n"


# Preparing
WORK_DIR=$APP_ROOT
TMP_DIR=/tmp/devpanel/quickstart
DUMPS_DIR=$TMP_DIR/dumps
STATIC_FILES_DIR=$WEB_ROOT/sites/default/files

mkdir -p $DUMPS_DIR

# Step 1 - Compress drupal database
cd $WORK_DIR
echo -e "> Export database to $APP_ROOT/.devpanel/dumps"
mkdir -p $APP_ROOT/.devpanel/dumps
drush cr --quiet
drush sql-dump --result-file=../.devpanel/dumps/db.sql --gzip --extra-dump=--no-tablespaces

# Step 2 - Compress static files
cd $WORK_DIR
echo -e "> Compress static files"
tar czf $DUMPS_DIR/files.tgz -C $STATIC_FILES_DIR .

echo -e "> Store files.tgz to $APP_ROOT/.devpanel/dumps"
mkdir -p $APP_ROOT/.devpanel/dumps
mv $DUMPS_DIR/files.tgz $APP_ROOT/.devpanel/dumps/files.tgz
