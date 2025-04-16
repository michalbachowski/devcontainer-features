#!/usr/bin/env bash
set -e

FEATURE_NAME=adr-tools
URL=https://github.com/npryce/adr-tools/archive/refs/tags/${VERSION}.tar.gz
ADR_TOOLS_DIRNAME=adr-tools-${VERSION}
DOWNLOAD_LOCATION=/usr/local/bin/adr-tools.tar.gz
INSTALL_LOCATION=/usr/local/bin/adr-tools
EXECUTABLE_PATH="${INSTALL_LOCATION}/adr"

. ./library_scripts.sh

title "${FEATURE_NAME}"

if [ -f $INSTALL_LOCATION ]; then
    echo "The [${FEATURE_NAME}] binary exists, skipping installation."
fi

if ! command -v curl >/dev/null; then
    echo ""
    echo "========================"
    echo "Command [curl] not found. Please install it first!"
    echo ""
    echo "========================"
    echo ""
    exit 1
fi

status=$(curl \
    --fail \
    --location \
    --write-out "%{http_code}" \
    --compressed \
    --output $DOWNLOAD_LOCATION \
    $URL)

if [ "$status" -ne 200 ] || [ ! -f $INSTALLER_LOCATION ]; then
    echo "The [${FEATURE_NAME}] binary could not be downloaded from [$URL; HTTP status: $status], please fix it!"
    exit 1
fi

create_dir "$INSTALL_LOCATION";

tar -C $INSTALL_LOCATION -xf $DOWNLOAD_LOCATION $ADR_TOOLS_DIRNAME/src --strip-components=2 
rm $DOWNLOAD_LOCATION
chmod +x $EXECUTABLE_PATH

echo 'Done!'
