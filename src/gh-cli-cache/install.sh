#!/usr/bin/env bash
set -e

FEATURE_NAME=gh-cli-cache

. ./library_scripts.sh

title $FEATURE_NAME

mkdir -p $GH_CONFIG_DIR
chown $_REMOTE_USER "$GH_CONFIG_DIR"
chmod 0766 "$GH_CONFIG_DIR"
echo "The details of the [$GH_CONFIG_DIR] are: $(ls -la $GH_CONFIG_DIR)"

echo Done
