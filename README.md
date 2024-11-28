# Dev Container Features

Some small features to avoid duplication on my daily work.

# Contents

## [bash-prompt](./src/bash-prompt/)

Fancy 2-row bash prompt.

## [bash-sensible](./src/bash-sensible/)

Adds the [sensible-bash](https://github.com/mrzool/bash-sensible/) to the `bashrc`.

## [custom-ca-cert](./src/custom-ca-cert/)

Sets some environment variables and adds custom configuration for some tools (eg. `keytool`, `pip`, `npm`) to use given custom CA cert.
The cert might be given by `SSL_CERT_FILE` environment variable or as a explicit option to the feature.
The feature **will not** copy or create the cert - it is user's duty to deliver the cert to the container (by adding it to the image or mount).
Note that if you decide to mount the certificate, the effects will be visible after the setup is done and the cert is available to the container processes.

## [detect-secrets](./src/detect-secrets/)

The feature installs the [detect-secrets](https://github.com/Yelp/detect-secrets) module via pipx.

## [pre-commit-initialize](./src/pre-commit-initialize/)

Initializes the [pre-commit](https://pre-commit.com) for the workspace folder.

## [pre-commit-cache](./src/pre-commit-cache/)

Sets up a common, persistent volume for `pre-commit` cache.

## [sbt-cache](./src/sbt-cache/)

Sets up a common, persistent volume for `sbt` / `coursier` packages.

## [scalafmt-native](./src/scalafmt-native/)

Installs the [scalafmt-native](https://scalameta.org/scalafmt/docs/installation.html#native-image) (pre-built GraalVm image).
Requires `curl` installed.

## [shell-execute-custom-script](./src/shell-execute-custom-script/)

Allows to easily add custom commands to be sourced by default by the `Bash` or `Zsh`.

## [shell-source-custom-script](./src/shell-source-custom-script/)

Allows to easily add custom commands to be sourced by default by the `Bash` or `Zsh`.
The file might be mounted to the container at runtime, since the code verifies if the file exists before sourcing it.

## [snyk-cli](./src/snyk-cli/)

Installs the [Snyk CLI](https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli) from binary.
Requires `curl` installed.

## [zsh-prompt-currenttime](./src/zsh-prompt-currenttime/)

Adds current time to the right side of the `Zsh` prompt (`$RPS1`)
