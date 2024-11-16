# Dev Container Features Development Notes

## Testing

### Run single type of tests for a single feature

```bash
make test-scenarios FEATURE=custom-ca-cert
```

### Running all test types for a given features

```bash
make test-all FEATURE=sbt-cache
```

Consult [Makefile](./Makefile) for all commands.

Special cases:
- `pre-commit-initialize` works only with custom scenarios.

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
Once you make some changes, update the version in the [`Makefile`](./Makefile) and re-build them by running:

```bash
make build-images
```

Then change all of the occurences of old images to point to new tag.
You can find the occurences by running from the top-level directory of this repository:

```bash
grep bachowskimichal/devcontainer-test -R *

```

Re-run local tests for features. If the test passes, push new images by running:

Once the images are pushed correctly, run:

```bash
docker login
make build-images PUSH=true
```
