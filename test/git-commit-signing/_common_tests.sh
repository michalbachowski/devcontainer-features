source test_scripts.sh

FEATURE_NAME=git-commit-signing

FEATURE_DIR="${COMMON_DIR}/${FEATURE_NAME}"
SETUP_FILE_PATH="${FEATURE_DIR}/git-setup.sh"

function check_config
{
    local opt="${1}"
    local val="${2}"

    check "The [$opt] prop with [$val] value is set in the [$SETUP_FILE_PATH] file" bash -c "cat $SETUP_FILE_PATH | grep -F '$opt' | grep -q -F '$val'"

    if [ "$CHECK_GIT" != "0" ]; then
        check "The [$opt] prop with [$val] value is set for current git repository" bash -c "test \$(git config '$opt') = '$val'"
    fi
}

check "DEBUG" bash -c "cat '${SETUP_FILE_PATH}'"

check "The [${FEATURE_DIR}] directory exists" bash -c "test -d '${FEATURE_DIR}'"
check "The [${SETUP_FILE_PATH}] file exists" bash -c "test -f '${SETUP_FILE_PATH}'"

check_config "gpg.format" "${FORMAT:-ssh}"
check_config "commit.gpgsign" "true"
check_config "tag.gpgsign" "true"

if [ "$FORCES_VERIFICATION_ON_MERGE" != "0" ]; then
    check_config "merge.verifySignatures" "true"
fi

if [ "$HAS_SIGNERS_FILE" != "0" ]; then
    check_config "gpg.ssh.allowedSignersFile" "./allowed_signers"
    check_config "log.showSignature" "true"
fi

if [ "$HAS_SMIMESIGN" = "1" ]; then
    check_config "gpg.x509.program" "smimesign"
fi
