#!/usr/bin/env bash
set -e

echo "Activating feature [pre-commit-initialize]"

function error_header
{
    echo "##########################################################################################"
    echo ""
    echo "Command [$1] not found"
    echo "Please install it manually via Dockerfile or use one of the following fetures:"
}

function error_footer
{
    echo ""
    echo "If you are using any other feature:"
    echo "1. make sure it is executed *before* the [pre-commit-initialize] feature"
    echo "   by using the [overrideFeatureInstallOrder] option in your devcontainer.json"
    echo "2. if you are using a public feature providing [pre-commit] tool"
    echo "   you can open a PR asking to add the feature to the [installsAfter] list of this feature"
    echo ""
    echo "##########################################################################################"
    exit 1
}

if ! command -v pre-commit; then
    error_header pre-commit
    echo "- ghcr.io/devcontainers-contrib/features/pre-commit",
    echo "- ghcr.io/gvatsal60/dev-container-features/pre-commit",
    echo "- ghcr.io/prulloac/devcontainer-features/pre-commit"
    error_footer
else
    echo "The [pre-commit] binary is available on \$PATH, proceeding."
fi

if ! command -v git; then
    error_header git
    echo "- ghcr.io/cirolosapio/devcontainers-features/alpine-git"
    echo "- ghcr.io/devcontainers/features/git"
    error_footer
fi

echo 'Done!'
