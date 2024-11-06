
# Allow to load any local file during shell init (shell-local)

Adds a step to load (source) custom shell scrip when initializing Bash or Zsh.

## Example Usage

```json
"features": {
    "ghcr.io/michalbachowski/devcontainer-features/shell-local:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| bash_script_path | Path to a script to be loaded when initializing Bash. | string | - |
| zsh_script_path | Path to a script to be loaded when initializing Zsh. | string | - |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/michalbachowski/devcontainer-features/blob/main/src/shell-local/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
