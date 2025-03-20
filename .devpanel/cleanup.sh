#!/usr/bin/env bash
set -eu -o pipefail

# Remove composer.json. A fresh one will be generated.
rm -f "${APP_ROOT}"/composer.json
