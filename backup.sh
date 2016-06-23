#!/bin/bash

# This script requires awscli to be installed, the environment variables
# AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to be set and a file named
# 'paths.txt' to exist in the current working directory. This file contains
# file/directory paths to be included in the backup to S3. An example
#'paths.txt' file is provided.

BUCKET="bucket"
BACKUP_FOLDER="backups"

if ! hash aws 2>/dev/null; then
  echo "awscli is not installed, please run 'pip install awscli' and try again. Exitting..."
  exit -1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY environment variables must be set. Exitting..."
fi

if ! [ -r paths.txt ]; then
  echo "No file named 'paths.txt' found in current working directory. Exitting..."
  exit -1
fi

NOW=$(date --iso-8601=seconds)
FILE=$BACKUP_FOLDER/$NOW.tar

mkdir -p $BACKUP_FOLDER
tar cf $FILE -T paths.txt

aws s3 cp $FILE s3://$BUCKET/
