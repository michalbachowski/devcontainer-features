#!/usr/bin/env bash
set -e

DEST=/usr/local/bin/snyk

echo "Activating feature [snyk-cli]"

if [ -f $DEST ]; then
    echo "Script exists, skipping"
    exit 0
fi

if ! command -v curl; then
    . ./library_scripts.sh

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

sysarch=$(uname -m)

case $sysarch in \
    "x86_64"*) snyk_arch=linux ;; \
    "arm64"*) snyk_arch=linux ;; \
    "aarch64"*) snyk_arch=linux-arm64 ;; \
    *) echo "\n========================\n\nUnkown platform $TARGETARCH. Update the install.sh to support it.\n\n========================\n" && exit 1 ;; \
esac

url=https://github.com/snyk/cli/releases/download/${VERSION}/snyk-${snyk_arch}

status=$(curl \
    --fail \
    --location \
    --write-out "%{http_code}" \
    --compressed \
    --output $DEST \
    $url)

if [ "$status" -ne 200 ] || [ ! -f $DEST ]; then
    echo "The snyk binary could not be downloaded from [$url; HTTP status: $status], please fix it!"
    exit 1
fi

chmod +x $DEST

echo 'Done!'
