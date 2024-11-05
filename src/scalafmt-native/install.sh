#!/usr/bin/env bash
set -e

URL=https://raw.githubusercontent.com/scalameta/scalafmt/v${VERSION}/bin/install-scalafmt-native.sh
INSTALL_LOCATION=/usr/local/bin/scalafmt-native
INSTALLER_LOCATION=/tmp/install-scalafmt-native.sh

if command -v scalafmt-native; then
    echo "The [scalafmt-native] binary exists, skipping installation."
fi

if ! command -v curl; then
    . ./library_scripts.bash

    # nanolayer is a cli utility which keeps container layers as small as possible
    # source code: https://github.com/devcontainers-contrib/nanolayer
    # `ensure_nanolayer` is a bash function that will find any existing nanolayer installations, 
    # and if missing - will download a temporary copy that automatically get deleted at the end 
    # of the script
    ensure_nanolayer nanolayer_location "v0.5.6"

    # install curl
    $nanolayer_location \
        install \
        devcontainer-feature \
        "ghcr.io/rocker-org/devcontainer-features/apt-packages:1" \
        --option packages='curl' --option version="$VERSION"
fi

status=$(curl \
    --fail \
    --location \
    --write-out "%{http_code}" \
    --compressed \
    --output $INSTALLER_LOCATION \
    $URL)

if [ "$status" -ne 200 ] || [ ! -f $INSTALLER_LOCATION ]; then
    echo "The [scalafmt-native] binary could not be downloaded from [$URL; HTTP status: $status], please fix it!"
    exit 1
fi

cat $INSTALLER_LOCATION | bash -s -- $VERSION $INSTALL_LOCATION

echo 'Done!'
