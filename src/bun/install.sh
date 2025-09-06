#!/usr/bin/env bash

set -e

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

# Canonicalize VERSION for Bun's tag scheme when pinning
version_for_release="$VERSION"
if [ "${VERSION:-latest}" != "latest" ] && [ -n "$VERSION" ]; then
    if [[ "$VERSION" =~ ^bun-v ]]; then
        version_for_release="$VERSION"
    elif [[ "$VERSION" =~ ^v ]]; then
        version_for_release="bun-$VERSION"
    else
        version_for_release="bun-v$VERSION"
    fi
fi

# Figure out arch and libc to disambiguate Bun's multiple Linux assets
arch_segment=""
case "$(uname -m)" in
    x86_64)
        arch_segment="x64"
        ;;
    aarch64|arm64)
        arch_segment="aarch64"
        ;;
    *)
        # Fallback to uname -m (unlikely used by bun release naming)
        arch_segment="$(uname -m)"
        ;;
esac

# Detect musl (Alpine) vs glibc
libc_suffix=""
if [ -x "/sbin/apk" ]; then
    libc_suffix="-musl"
fi

# Prefer baseline builds for widest CPU compatibility; exclude profile variants
# Examples matched:
# - bun-linux-x64-baseline.zip
# - bun-linux-x64-musl-baseline.zip
# - bun-linux-aarch64-baseline.zip
# - bun-linux-aarch64-musl-baseline.zip
asset_regex="^bun-linux-${arch_segment}${libc_suffix}-baseline\\.zip$"

# Bun tags are of the form 'bun-vX.Y.Z'; constrain tag discovery accordingly
release_tag_regex="^bun-v"

# Install Bun via gh-release helper with explicit asset/tag filters
$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1" \
    --option repo='oven-sh/bun' \
    --option binaryNames='bun' \
    --option version="$version_for_release" \
    --option assetRegex="$asset_regex" \
    --option releaseTagRegex="$release_tag_regex"

# Provide a convenient bunx shim
if [ -x "/usr/local/bin/bun" ] && ! [ -x "/usr/local/bin/bunx" ]; then
    cat >/usr/local/bin/bunx <<'EOF'
#!/usr/bin/env bash
exec bun x "$@"
EOF
    chmod +x /usr/local/bin/bunx
fi

echo 'Bun installation completed.'
