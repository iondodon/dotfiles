#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  unset pass1 pass2
}
trap cleanup EXIT

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 output.7z input1 [input2 ...]"
  exit 1
fi

archive="$1"
shift

read -rsp "Enter password: " pass1
echo
read -rsp "Confirm password: " pass2
echo

[[ -n "$pass1" ]] || { echo "Error: empty password is not allowed."; exit 1; }
[[ "$pass1" == "$pass2" ]] || { echo "Error: passwords do not match."; exit 1; }

7z a -t7z -mhe=on "-p$pass1" "$archive" "$@"

echo "Archive created: $archive"
