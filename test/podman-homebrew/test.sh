#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "podman --version" podman --version

reportResults
