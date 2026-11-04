#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/landing"
exec ./bin/rails server "$@"
