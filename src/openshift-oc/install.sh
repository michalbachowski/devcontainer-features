#!/usr/bin/env bash
set -e

BIN_DIR="/devcontainer-feature/michalbachowski/openshift-oc/"
BIN_NAME=oc
BIN_PATH="${BIN_DIR}/${BIN_NAME}"
DOWNLOAD_LOCATION="${BIN_DIR}/${BIN_NAME}.tar.gz"
FEATURE_NAME="openshift-${BIN_NAME}"

. ./library_scripts.sh

title "${FEATURE_NAME}"

if command -v "$BIN_NAME" >/dev/null; then
    echo "Script exists, skipping"
    exit 0
fi

ensure_common_dir
create_dir "${BIN_DIR}";

if [ "${VERSION}" == "latest" ] || [ "${VERSION}" == "stable" ]; then
    MAJOR_VERSION="4"
else
    MAJOR_VERSION="${VERSION%%.*}"
fi

sysarch=$(uname -m)

case $sysarch in \
    "x86_64"*)
        download_url_v3_arch=""
        download_url_v4_arch=""
        ;;
    "arm64"*)
        download_url_v3_arch="-aarch64"
        download_url_v4_arch="-arm64"
        ;;
    "aarch64"*)
        download_url_v3_arch="-aarch64"
        download_url_v4_arch="-arm64"
        ;;
    *) echo "\n========================\n\nUnkown platform $TARGETARCH. Update the install.sh to support it.\n\n========================\n" && exit 1 ;;
esac

download_url="https://mirror.openshift.com/pub/openshift-v${MAJOR_VERSION}/clients"

case $MAJOR_VERSION in \
    "4")
        download_url="${download_url}/ocp/${VERSION}/openshift-client-linux${download_url_v4_arch}.tar.gz"
        ;;
    "3")
        download_url="${download_url}/${VERSION}/linux${download_url_v3_arch}/oc.tar.gz"
        ;;
    *) echo "\n========================\n\nUnkown MAJOR_VERSION $MAJOR_VERSION. Update the install.sh to support it.\n\n========================\n" && exit 1 ;;
esac

echo "${download_url}";

curl \
    -k \
    --proto '=https' \
    --tlsv1.2 \
    -LsSf \
    "$download_url" \
    --output "${DOWNLOAD_LOCATION}";

tar -C "${BIN_DIR}" -xf "${DOWNLOAD_LOCATION}" oc;

rm "${DOWNLOAD_LOCATION}";

set_common_ownership "${BIN_PATH}"

echo 'Done!'
