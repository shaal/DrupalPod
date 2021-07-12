#!/bin/bash -e

if [ -n "$DEBUG_DRUPALPOD" ]; then
    set -x
fi

# Check that an AWS bucket name was defined
if [ -n "$AWS_DEFAULT_BUCKET" ]; then
    if [ -n "$1" ]; then
        # Specific backup
        BACKUP_NAME=$1
    else
        # Latest backup
        ALL_FILES=$(aws s3 ls "$AWS_DEFAULT_BUCKET"); LATEST_BACKUP_FILE=$(echo "$ALL_FILES" | sort -r | awk 'NR==1 {print $NF}'); echo "$LATEST_BACKUP_FILE"
        BACKUP_NAME=$(echo "$LATEST_BACKUP_FILE" | tr -d '.tar.gz')
    fi
    if ! [ -d .ddev/db_snapshots/"$BACKUP_NAME" ]; then
        BACKUP_FILE=$BACKUP_NAME.tar.gz
        mkdir -p .ddev/db_snapshots
        aws s3 cp s3://"$AWS_DEFAULT_BUCKET"/"$BACKUP_FILE" /tmp/.
        tar xzf /tmp/"$BACKUP_FILE"
    fi
    ddev snapshot restore "$BACKUP_NAME"
else
    echo "No bucket defined in AWS_DEFAULT_BUCKET"
    exit 1
fi
