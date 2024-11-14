#!/usr/bin/env bash
set -e

FEATURE_NAME=sbt-cache

. ./library_scripts.sh

title $FEATURE_NAME

mkdir -p $COURSIER_CACHE
chown $_REMOTE_USER "$COURSIER_CACHE"
chmod 0766 "$COURSIER_CACHE"
echo "The details of the [$COURSIER_CACHE] are: $(ls -la $COURSIER_CACHE)"

echo Done
