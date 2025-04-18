#!/usr/bin/env bash
set -e

FEATURE_NAME=git-commit-signing
SETUP_FILE_NAME="git-setup.sh"

. ./library_scripts.sh

title "${FEATURE_NAME}"

echo "${REPO_PATH}"

if ! command -v git >/dev/null; then
    echo ""
    echo "========================"
    echo "Command [git] not found. Please install it first!"
    echo ""
    echo "========================"
    echo ""
    exit 1
fi

function set-git-config
{
    local option="$1"
    local value="$2"
    git config --system "${option}" "${value}"
}

set-git-config commit.gpgsign true
set-git-config gpg.format "$KEY_FORMAT"
set-git-config tag.gpgsign true
set-git-config user.signingkey "$SIGNING_KEY"

if [ "${KEY_FORMAT}" == 'x509' ]; then
    set-git-config gpg.x509.program smimesign
fi

if [ -n "$ALLOWED_SIGNERS_FILE" ]; then
    set-git-config gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS_FILE"
    set-git-config log.showSignature true
fi

if [ "$FORCE_VERIFICATION_ON_MERGE" == 'true' ]; then
    set-git-config merge.verifySignatures true
fi

echo Done
