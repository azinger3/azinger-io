#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 0 ]; then
  echo "Usage: $0" >&2
  exit 2
fi

log_file="${LANDING_DATA_ROOT:-/Users/rob/azinger.io}/log/production.log"
if [ ! -f "$log_file" ]; then
  echo "Log file not found: $log_file" >&2
  exit 1
fi

: > "$log_file"
echo "Cleared $log_file"
