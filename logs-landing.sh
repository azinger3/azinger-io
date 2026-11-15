#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -gt 1 ]; then
  echo "Usage: $0 [production|development]" >&2
  exit 2
fi

case "${1:-production}" in
  production)
    log_file="${LANDING_DATA_ROOT:-/Users/rob/azinger.io}/log/production.log"
    ;;
  development)
    log_file="${LANDING_LOG_DIR:-$HOME/azinger.io/log}/development.log"
    ;;
  *)
    echo "Usage: $0 [production|development]" >&2
    exit 2
    ;;
esac

exec tail -n 100 -F "$log_file"
