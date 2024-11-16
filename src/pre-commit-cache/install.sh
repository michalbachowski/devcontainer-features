#!/usr/bin/env bash
set -e

FEATURE_NAME=pre-commit-cache

. ./library_scripts.sh

title $FEATURE_NAME

mkdir -p $PRE_COMMIT_HOME
chown $_REMOTE_USER "$PRE_COMMIT_HOME"
chmod 0766 "$PRE_COMMIT_HOME"
echo "The details of the [$PRE_COMMIT_HOME] are: $(ls -la $PRE_COMMIT_HOME)"

echo Done
