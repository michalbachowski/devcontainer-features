#!/usr/bin/env bash
set -e

FEATURE_NAME=git-commit-signing
SETUP_FILE_NAME="git-setup.sh"

. ./library_scripts.sh

title "${FEATURE_NAME}"

copy_feature_files feature_cache_dir "${FEATURE_NAME}"

DEST_FILE="${feature_cache_dir}/${SETUP_FILE_NAME}"

function write-git-config
{
    local option="$1"
    local value="$2"
    echo "git config '${option}' '${value}'" >> "${DEST_FILE}"
}

if [ -f "${DEST_FILE}" ]; then
    echo "The [${FEATURE_NAME}] binary exists, skipping installation."
fi

cat > "${DEST_FILE}" \
<< EOF
#!/bin/sh

if [ ! -d "./.git" ]; then
    echo "Not a git directory - Git signing was NOT setup for you!";
    exit 1;
fi

set -e
EOF

set_common_ownership "${DEST_FILE}"
chmod +x "${DEST_FILE}"

write-git-config commit.gpgsign true
write-git-config gpg.format "$KEY_FORMAT"
write-git-config tag.gpgsign true
write-git-config user.signingkey "$SIGNING_KEY"

if [ "${KEY_FORMAT}" == 'x509' ]; then
    write-git-config gpg.x509.program smimesign
fi

if [ -n "$ALLOWED_SIGNERS_FILE" ]; then
    write-git-config gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS_FILE"
    write-git-config log.showSignature true
fi

if [ "$FORCE_VERIFICATION_ON_MERGE" == 'true' ] || [ -n "$ALLOWED_SIGNERS_FILE" ]; then
    write-git-config merge.verifySignatures true
fi

echo Done
