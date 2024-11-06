# Dev Container Features Development Notes

## Running tests

```bash
make test-all FEATURE<feature-name>
```

See [Makefile](./Makefile) for more commands.

Special cases:
- `pre-commit-initialize` works only with custom scenarios.

## Building images

```bash
make build-images
```
