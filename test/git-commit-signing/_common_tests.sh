source test_scripts.sh

FEATURE_NAME=git-commit-signing

function check_config
{
    local opt="${1}"
    local val="${2}"

    check "The [$opt] prop with [$val] value is set for current git repository" bash -c "test \"\$(git config --system '$opt')\" = '$val'"
}

check "DEBUG" bash -c "git config --system --list"

check_config "gpg.format" "${FORMAT:-ssh}"
check_config "commit.gpgsign" "true"
check_config "tag.gpgsign" "true"

if [ "$FORCES_VERIFICATION_ON_MERGE" = "1" ]; then
    check_config "merge.verifySignatures" "true"
fi

if [ -n "$ALLOWED_SIGNERS" ]; then
    check_config "gpg.ssh.allowedSignersFile" "${ALLOWED_SIGNERS}"
    check_config "log.showSignature" "true"
fi

if [ "$HAS_SMIMESIGN" = "1" ]; then
    check_config "gpg.x509.program" "smimesign"
fi
