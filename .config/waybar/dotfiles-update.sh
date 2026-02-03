#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"

get_update_count() {
	if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		echo -1
		return 0
	fi

	if ! git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
		echo -2
		return 0
	fi

	git -C "$REPO_DIR" fetch --quiet --prune --no-tags || true
	git -C "$REPO_DIR" rev-list --count HEAD..@{u} 2>/dev/null || echo 0
}


print_status() {
	local count
	count="$(get_update_count)"
	if [[ "$count" -eq -1 ]]; then
		echo '{"text":"Dotfiles","tooltip":"Dotfiles repo not found","class":"inactive"}'
		return 0
	fi

	if [[ "$count" -eq -2 ]]; then
		echo '{"text":"Dotfiles","tooltip":"No upstream configured","class":"inactive"}'
		return 0
	fi

	if [[ "$count" -gt 0 ]]; then
		echo "{\"text\":\"${count} commits Dotfiles\",\"tooltip\":\"Updates available\",\"class\":\"update-available\"}"
	else
		echo '{"text":"Dotfiles","tooltip":"Up to date","class":"up-to-date"}'
	fi
}

case "${1:-status}" in
	status|"")
		print_status
		;;
	*)
		echo "Usage: $0 [status]" >&2
		exit 2
		;;
 esac
