#!/bin/bash -e

if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Check that an AWS bucket name was defined
if [ -n "$AWS_DEFAULT_BUCKET" ]; then
    # User defined backup
    if [ -n "$1" ]; then
        BACKUP_NAME=$1
    else
        # Default backup_name - current UTC date & time
        BACKUP_NAME=$(date +"%Y-%m-%d__%H-%M-%S")
    fi
    ddev snapshot --name "$BACKUP_NAME"
    tar zcf /tmp/"$BACKUP_NAME".tar.gz .ddev/db_snapshots/"$BACKUP_NAME"
    aws s3 mv /tmp/"$BACKUP_NAME".tar.gz s3://"$AWS_DEFAULT_BUCKET"
else
    echo "No bucket defined in AWS_DEFAULT_BUCKET"
    exit 1
fi
