# Additional Notes

- Requires Bun to be installed (e.g., via the `bun` feature).
- Exports `BUN_INSTALL=/usr/local` to ensure global binaries land in `/usr/local/bin`.
- Useful for installing tools distributed as Bun packages (e.g., `@vercel/turbo`).
- Accepts both bare names and `npm:`-prefixed names; Bun defaults to npm registry, so `npm:` is optional.

## Behavior

- Requires root to install globally to `/usr/local` (matches other package helper features).
- Skip-if-installed:
  - For `version: "latest"` (or empty), skips when the package is already present in `bun pm -l`.
  - For pinned installs (e.g., `"version": "1.2.3"`), skips only when the exact `<name>@<version>` is already installed.
- For non-npm specs (git / URL / GitHub shorthand), use `nameHint` if the name shown by `bun pm -l` differs from your install spec.

## Usage Examples

Default latest:

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun-package:1": {
    "package": "@vercel/turbo"
  }
}
```

Pinned version:

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun-package:1": {
    "package": "@vercel/turbo",
    "version": "2.5.6"
  }
}
```

## Non-npm sources

- Supports any spec Bun accepts in `bun add`, including git URLs (e.g., `git+https://...`), GitHub shorthand (e.g., `github:user/repo`), and tarball URLs.
- For non-npm sources, the name shown in `bun pm -l` may not match the install spec. Use the optional `nameHint` option to tell the feature which name to look for when deciding to skip.

### Non-NPM Usage Examples

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun:1": {},
  "ghcr.io/devcontainers-extra/features/bun-package:1": {
    "package": "git+https://github.com/user/tool.git",
    "nameHint": "tool"
  }
}
```

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun:1": {},
  "ghcr.io/devcontainers-extra/features/bun-package:1": {
    "package": "github:user/repo",
    "nameHint": "repo"
  }
}
```

Note: Private registries (e.g., GitHub Packages, Artifactory) may require registry / auth setup via `.npmrc` or Bun config in the container.

## Support

- Distros: `Debian` / `Ubuntu` and `Alpine`
- Architectures: `x86_64` and `arm64`
