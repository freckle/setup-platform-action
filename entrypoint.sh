#!/bin/sh
set -eu

usage() {
  cat <<EOM
Usage: /entrypoint.sh <-t TOKEN> <-c CMD>
Options:
  -t TOKEN      GitHub token for downloading Platform CLI asset
  -c CMD        Command to run, via \`sh -c'
EOM
}

token=
cmd=

while getopts t:c:h opt; do
  case "$opt" in
    t)
      token=$OPTARG
      ;;
    c)
      cmd=$OPTARG
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      usage >&2
      exit 64
      ;;
  esac
done
shift $((OPTIND - 1))

if [ -z "$token" ]; then
  echo "-t is required" >&2
  usage >&2
  exit 64
fi

if [ -z "$cmd" ]; then
  echo "-c is required" >&2
  usage >&2
  exit 64
fi

read -r release </PLATFORM_VERSION
echo "Installing platform-$release"

tmp=$(mktemp)

if ! platform-setup "$token" "$release" >"$tmp" 2>&1; then
  echo "Installation failed:" >&2
  cat "$tmp"
  exit 1
fi

exec sh -c "$cmd"
