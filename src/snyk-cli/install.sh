#!/usr/bin/env bash
set -e

sysarch=$(uname -m)

case $sysarch in \
    "x86_64"*) snyk_arch=linux ;; \
    "arm64"*) snyk_arch=linux ;; \
    "aarch64"*) snyk_arch=linux-arm64 ;; \
    *) echo "\n========================\n\nUnkown platform $TARGETARCH. Update the install.sh to support it.\n\n========================\n" && exit 1 ;; \
esac

dest=/usr/local/bin/snyk
url=https://github.com/snyk/cli/releases/download/${VERSION}/snyk-${snyk_arch}

status=$(curl \
    --fail \
    --location \
    --write-out "%{http_code}" \
    --compressed \
    --output $dest \
    $url)

if [ "$status" -ne 200 ] || [ ! -f $dest ]; then
    echo "The snyk binary could not be downloaded from [$url; HTTP status: $status], please fix it!"
    exit 1
fi

chmod +x $dest

echo 'Done!'
