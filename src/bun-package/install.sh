#!/usr/bin/env bash

set -e

PACKAGE=${PACKAGE:-""}
VERSION=${VERSION:-"latest"}
NAMEHINT=${NAMEHINT:-""}

if [ -z "$PACKAGE" ]; then
    echo "'package' option is empty, skipping"
    exit 0
fi

# Require root (global install to /usr/local)
if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as\n    root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Ensure bun exists
if ! command -v bun >/dev/null 2>&1; then
    echo "Bun is required. Ensure a Bun feature (bun) ran before this feature."
    exit 1
fi

# Ensure global binaries land in /usr/local/bin
export BUN_INSTALL="/usr/local"

# Normalize optional npm: prefix; Bun defaults to npm registry
base_pkg="$PACKAGE"
if [[ "$base_pkg" == npm:* ]]; then
    base_pkg="${base_pkg#npm:}"
fi

# Name used for skip checks (helps for git / URL / non-npm registry installs)
skip_name="$base_pkg"
if [ -n "$NAMEHINT" ]; then
    skip_name="$NAMEHINT"
fi

# Resolve list command (prefer global). Bun uses 'pm ls'. If unavailable, skip detection.
list_cmd=""
if bun pm ls -g >/dev/null 2>&1; then
    list_cmd="bun pm ls -g"
elif bun pm ls >/dev/null 2>&1; then
    list_cmd="bun pm ls"
fi

# Skip when already present
if [ -n "$list_cmd" ]; then
    if [ "$VERSION" = "latest" ] || [ -z "$VERSION" ]; then
        if $list_cmd | grep -q "$skip_name"; then
            echo "$skip_name already exists - skipping installation"
            exit 0
        fi
    else
        # For pinned versions, skip only if exact version already installed
        if $list_cmd | grep -q "${skip_name}@${VERSION}"; then
            echo "$skip_name@${VERSION} already exists - skipping installation"
            exit 0
        fi
    fi
fi

# Compose installation spec
pkg="$base_pkg"
if [ "$VERSION" != "latest" ] && [ -n "$VERSION" ]; then
    pkg="$base_pkg@$VERSION"
fi

# Install globally via Bun with basic retries to handle transient registry errors (e.g., 5xx)
max_attempts=4
attempt=1
while true; do
    if bun add --global "$pkg"; then
        break
    fi
    exit_code=$?
    if [ "$attempt" -ge "$max_attempts" ]; then
        echo "bun add failed after ${attempt} attempts (exit code $exit_code)"
        exit "$exit_code"
    fi
    sleep_seconds=$(( attempt * attempt ))
    echo "bun add failed (exit code $exit_code). Retrying in ${sleep_seconds}s... (${attempt}/${max_attempts})"
    sleep "$sleep_seconds"
    attempt=$(( attempt + 1 ))
done

echo 'Done!'
