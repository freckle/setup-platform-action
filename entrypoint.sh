#!/bin/sh
read -r release </PLATFORM_VERSION
echo "Installing platform-$release"

tmp=$(mktemp)

if ! platform-setup "$release" >"$tmp" 2>&1; then
  echo "Installation failed:" >&2
  cat "$tmp"
  exit 1
fi

exec "$@"
