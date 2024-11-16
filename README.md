# Dev Container Features

Some small features to avoid duplication on my daily work.

# Contents

## [bash-prompt](./src/bash-prompt/)

Fancy 2-row bash prompt.
If you mount the `~/.basrc` it is enough to source the `/devcontainer-feature/michalbachowski/bashrc` to enable all installed Bash-related features from this repo.

## [bash-sensible](./src/bash-sensible/)

Adds the [sensible-bash](https://github.com/mrzool/bash-sensible/) to the `bashrc`.
If you mount the `~/.basrc` it is enough to source the `/devcontainer-feature/michalbachowski/bashrc` to enable all installed Bash-related features from this repo.

## [custom-ca-cert](./src/custom-ca-cert/)

Sets some environment variables and adds custom configuration for some tools (eg. `keytool`, `pip`, `npm`) to use given custom CA cert.
The cert might be given by `SSL_CERT_FILE` environment variable or as a explicit option to the feature.
The feature **will not** copy or create the cert - it is user's duty to deliver the cert to the container (by adding it to the image or mount).
Note that if you decide to mount the certificate, the effects will be visible after the setup is done and the cert is available to the container processes.

## [pre-commit-initialize](./src/pre-commit-initialize/)

Initializes the [pre-commit](https://pre-commit.com) for the workspace folder.

## [pre-commit-cache](./src/pre-commit-cache/)

Sets up a common, persistent volume for `pre-commit` cache.

## [sbt-cache](./src/sbt-cache/)

Sets up a common, persistent volume for `sbt` / `coursier` packages.

## [scalafmt-native](./src/scalafmt-native/)

Installs the [scalafmt-native](https://scalameta.org/scalafmt/docs/installation.html#native-image) (pre-built GraalVm image).
Requires `curl` installed.

## [shell-local](./src/shell-local/)

Allows to easily add custom commands to be sourced by default by the `Bash` or `Zsh`.
The file might be mounted to the container, since the code verifies if the file exists before sourcing it.

If you mount the `~/.bashrc` or `~/.zshrc` it is enough to source the `/devcontainer-feature/michalbachowski/bashrc` or `/devcontainer-feature/michalbachowski/zshrc` respectively to enable all installed Bash/Zsh-related features from this repo.

## [snyk-cli](./src/snyk-cli/)

Installs the [Snyk CLI](https://docs.snyk.io/snyk-cli/install-or-update-the-snyk-cli) from binary.
Requires `curl` installed.

## [zsh-prompt-currenttime](./src/zsh-prompt-currenttime/)

Adds current time to the right side of the `Zsh` prompt (`$RPS1`)
If you mount the `~/.zshrc` it is enough to source the `/devcontainer-feature/michalbachowski/zshrc` to enable all installed Zsh-related features from this repo.

# Development

For local development use existing DevContainer.

## Syncing common file

Features contain some common code stored in the `library_scripts.sh` (for feature execution) and `test_scripts.sh` (for tests).
The files are kept in sync - each feature contains the same file (regardles if anything from the common code is actually used or not).

To verify is files are out of sync:

```bash
make cmp-files
make cmp-files IN=test FILE=test_scripts.sh
```

To keep files in sync, run the following once you are done with your changes:

For `library_scripts.sh`:
```bash
make sync-files FROM=<source-feature-name>
```

For `test_scripts.sh`:
```bash
make sync-files FROM=<source-feature-name> IN=test FILE=test_scripts.sh
```

## Building custom Docker images

There are 2 custom docker images build to support testing.
Once you make some changes, update the version in the `Makefile`[./Makefile] and re-build them by running:

```bash
make build-images
```

Then change all of the occurences of old images to point to new tag.
You can find the occurences by running:

```bash
grep bachowskimichal/devcontainer-test -R *

```

Re-run local tests for features. If the test passes, push new images by running:

```bash
docker login
make build-images PUSH=true
```

## Testing

Reference [Makefile](./Makefile) for commands.

### Run single type of tests for a single feature

```bash
make test-scenarios FEATURE=custom-ca-cert
```

### Running all test types for a given features

```bash
make test-all FEATURE=sbt-cache
```

> [!WARNING]
> Not all features have defined all possible test types (eg. [pre-commit-initialize](./src/pre-commit-initialize/) has only scenario-based tests defined).

