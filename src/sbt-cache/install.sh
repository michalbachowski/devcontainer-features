#!/usr/bin/env bash
set -e

FEATURE_NAME=sbt-cache

. ./library_scripts.sh

title $FEATURE_NAME

mkdir -p $COURSIER_PATH
chown $_REMOTE_USER "$COURSIER_PATH"
chmod 0766 "$COURSIER_PATH"
echo "The details of the [$COURSIER_PATH] are: $(ls -la $COURSIER_PATH)"

echo Done
