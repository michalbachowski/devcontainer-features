#!/usr/bin/env bash
set -e

URL=https://raw.githubusercontent.com/scalameta/scalafmt/v${VERSION}/bin/install-scalafmt-native.sh
INSTALL_LOCATION=/usr/local/bin/scalafmt-native
INSTALLER_LOCATION=/tmp/install-scalafmt-native.sh

echo "Activating feature [scalafmt-native]"

if -f $INSTALL_LOCATION; then
    echo "The [scalafmt-native] binary exists, skipping installation."
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

# the SSL_CERT_FILE=/envcert.pem is used for testing, thus removing it here
[ "$SSL_CERT_FILE" = "/envcert.pem" ] && unset SSL_CERT_FILE

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
