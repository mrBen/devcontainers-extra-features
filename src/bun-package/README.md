# Bun package (bun-package)

Installs a Bun package globally using Bun. Ensures system-wide bin availability.

## Example Usage

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun-package:1": {
    "package": "@vercel/turbo",
    "version": "latest"
  }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| package | Select the Bun package to install globally. | string |  |
| version | Select the version of the Bun package to install. | string | latest |
| nameHint | Optional: name to use for skip checks (useful for git / URL / non-npm sources). | string |  |

---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
