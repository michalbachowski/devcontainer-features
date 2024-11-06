#!/usr/bin/env bash
set -e

DEST=/usr/local/bin/snyk

echo "Activating feature [snyk-cli]"

if [ -f $DEST ]; then
    echo "Script exists, skipping"
    exit 0
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
