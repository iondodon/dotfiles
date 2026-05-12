#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${USER:-}"

if [ -z "$TARGET_USER" ]; then
  echo "install.sh: USER is not set" >&2
  exit 2
fi

link_file() {
  local source="$1"
  local rel="$2"
  local target

  case "$rel" in
    home/USER/*)
      target="/home/$TARGET_USER/${rel#home/USER/}"
      ;;
    *)
      target="/$rel"
      ;;
  esac

  if [ -e "$target" ] || [ -L "$target" ]; then
    if [ "$(readlink -- "$target" || true)" = "$source" ]; then
      printf 'exists  %s -> %s\n' "$target" "$source"
      return
    fi

    if read -r -p "override $target? [y/N] " answer && [[ "$answer" =~ ^[Yy]$ ]]; then
      rm -rf -- "$target"
    else
      printf 'skip    %s exists\n' "$target"
      return
    fi
  fi

  printf 'link    %s -> %s\n' "$target" "$source"
  mkdir -p -- "$(dirname -- "$target")"
  ln -s -- "$source" "$target"
}

while IFS= read -r -d '' source; do
  rel="${source#$ROOT/}"

  case "$rel" in
    .git/*|.git|.codex/*|.codex|.agents/*|.agents|README.md|.gitignore|install.sh)
      continue
      ;;
  esac

  link_file "$source" "$rel"
done < <(
  find "$ROOT" \
    \( -path "$ROOT/.git" -o -path "$ROOT/.codex" -o -path "$ROOT/.agents" \) -prune \
    -o \( -type f -o -type l \) -print0
)
