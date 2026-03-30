#!/usr/bin/env bash

CERT_DEST_PATH='/usr/local/share/ca-certificates/custom-ca-cert.crt'
CERT_SOURCE_PATH="./custom-ca.crt"
NANOLAYER_VERSION="0.5.6"

if [ ! -f "${CERT_SOURCE_PATH}" ]; then
    echo "The [${CERT_SOURCE_PATH}] custom certificate not found, skipping installing the feature!";
    exit 0;
fi

cp -r "$CERT_SOURCE_PATH" "$CERT_DEST_PATH"
chown -R root:root "$CERT_DEST_PATH"
chmod -R 0555 "$CERT_DEST_PATH"

set +u;
. ./ensure_nanolayer.sh;
ensure_nanolayer nanolayer_location "v${NANOLAYER_VERSION}";

$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/michalbachowski/devcontainer-features/custom-ca-cert:0" \
        --option "update_cert_stores_during_build=true"
