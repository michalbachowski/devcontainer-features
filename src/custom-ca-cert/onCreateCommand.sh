#!/usr/bin/env bash

echo "Running onCreateCommand for [custom-ca-cert] feature"

FEATURE_DIR=/devcontainer-feature/michalbachowski/custom-ca-cert

if [ -f "${FEATURE_DIR}/update_cert_stores_during_build.mark" ]; then
    ${FEATURE_DIR}/update_cert_stores.sh
fi

echo "Done"
