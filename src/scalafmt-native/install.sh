#!/usr/bin/env bash
set -e

URL=https://raw.githubusercontent.com/scalameta/scalafmt/v${VERSION}/bin/install-scalafmt-native.sh
INSTALL_LOCATION=/usr/local/bin/scalafmt-native
INSTALLER_LOCATION=/tmp/install-scalafmt-native.sh

status=$(curl \
    --fail \
    --location \
    --write-out "%{http_code}" \
    --compressed \
    --output $INSTALLER_LOCATION \
    $URL)

if [ "$status" -ne 200 ] || [ ! -f $INSTALLER_LOCATION ]; then
    echo "The snyk binary could not be downloaded from [$URL; HTTP status: $status], please fix it!"
    exit 1
fi

cat $INSTALLER_LOCATION | bash -s -- $VERSION $INSTALL_LOCATION

echo 'Done!'
