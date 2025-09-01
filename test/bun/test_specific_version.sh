#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "Bun version is equal to 1.2.21 (via GitHub Releases)" sh -c "bun --version | grep '^1.2.21'"

reportResults
