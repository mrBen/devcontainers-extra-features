# Additional Notes

- Bun Website: [https://bun.com/](https://bun.com/)
- Bun GitHub: [https://github.com/oven-sh/bun](https://github.com/oven-sh/bun)

## Install Method

This feature installs Bun via the repository's `gh-release` helper, which downloads the correct release asset for the current platform and architecture and places the `bun` binary in `/usr/local/bin`. This follows the repo’s best practices for reproducibility and small image layers.

## bunx shim

Bun supports executing binaries with `bun x <pkg>`. Some environments/tools expect a `bunx` executable. To provide a consistent experience, this feature adds a small shim at `/usr/local/bin/bunx` that forwards to `bun x`. If the upstream release reliably includes a `bunx` binary in the future, the shim can be removed without breaking users.

## Usage Examples

Default (latest):

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun:1": {}
}
```

Pin a specific version:

```json
"features": {
  "ghcr.io/devcontainers-extra/features/bun:1": {
    "version": "1.1.38"
  }
}
```

## Support

- Distros: `Debian` / `Ubuntu` and `Alpine`
- Architectures: `x86_64` and `arm64`

## Tests

This feature is tested against various Distro:

- `Ubuntu` (latest)
- `Debian` (latest)
- `Alpine` (latest)
- `Debian` with a pinned version of Bun (e.g., Bun `v1.1.38`)

## Considerations / Future Enhancements

- If Bun’s release assets ever require explicit filtering, we can wire an `assetRegex` or pass `additionalFlags` to the `gh-release` helper. The helper already auto-filters by platform/arch, so no extra flags are set currently.
- Coexistence with Node.js: this feature only installs `bun` and a `bunx` shim and does not modify Node.js.
- PATH/profile: installation to `/usr/local/bin` avoids profile changes.
