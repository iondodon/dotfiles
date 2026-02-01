#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"


print_status() {
	if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		echo '{"text":"Dotfiles","tooltip":"Dotfiles repo not found","class":"inactive"}'
		return 0
	fi

	if ! git -C "$REPO_DIR" rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
		echo '{"text":"Dotfiles","tooltip":"No upstream configured","class":"inactive"}'
		return 0
	fi

	git -C "$REPO_DIR" fetch --quiet --prune --no-tags || true
	local count
	count=$(git -C "$REPO_DIR" rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
	if [[ "$count" -gt 0 ]]; then
		echo '{"text":"Dotfiles","tooltip":"Updates available","class":"update-available"}'
	else
		echo '{"text":"Dotfiles","tooltip":"Up to date","class":"up-to-date"}'
	fi
}

launch_terminal() {
	local payload="$1"
	local launched=0

	if command -v ghostty >/dev/null 2>&1; then
		ghostty -e bash -lc "$payload" &
		launched=1
	fi

	if [[ "$launched" -eq 1 ]]; then
		disown || true
		return 0
	fi

	return 1
}

run_update_flow() {
	if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
		echo "Dotfiles repo not found at $REPO_DIR"
		read -r -p "Press Enter to close." _
		return 1
	fi

	echo "Dotfiles repo: $REPO_DIR"
	read -r -p "Update dotfiles from remote? [y/N] " answer
	case "${answer,,}" in
		y|yes)
			if git -C "$REPO_DIR" pull --rebase --autostash; then
				echo "Update complete."
			else
				echo "Update failed."
				read -r -p "Press Enter to close." _
				return 1
			fi
			;;
		*)
			echo "Update cancelled."
			read -r -p "Press Enter to close." _
			return 0
			;;
	esac

	read -r -p "Reboot now? [y/N] " reboot_answer
	case "${reboot_answer,,}" in
		y|yes)
			echo "Rebooting..."
			systemctl reboot
			;;
		*)
			echo "Reboot cancelled."
			;;
	esac

	read -r -p "Press Enter to close." _
}

case "${1:-status}" in
	status|"")
		print_status
		;;
	prompt)
		launch_terminal "$HOME/.config/waybar/dotfiles-update.sh run" || {
			echo "Failed to launch terminal" >&2
			exit 1
		}
		;;
	run)
		run_update_flow
		;;
	*)
		echo "Usage: $0 [status|prompt|run]" >&2
		exit 2
		;;
 esac
