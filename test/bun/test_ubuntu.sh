#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "Bun is installed (via GitHub Releases)" bun --version

reportResults
