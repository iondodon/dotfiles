#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
TARGET_USER="${USER:-}"

PACMAN_PACKAGES=(
  sddm
  niri
  waybar
  mako
  swaylock
  blueman
  ttf-nerd-fonts-symbols
  flameshot
  nautilus
  vicious
  gammastep
  xclip
  xsel
  ttf-jetbrains-mono
  arandr
  wl-clipboard
  shellcheck
  swaybg
  network-manager-applet
  systemctl-tui
  caligula
  swayidle
  fuzzel
  grim
  pacman-contrib
  xwayland-satellite
  fastfetch
  7zip
)

YAY_PACKAGES=(
  ttf-jetbrains-mono
  fsearch
  yaru-gtk-theme
  outlook-for-linux
)

if [ -z "$TARGET_USER" ]; then
  echo "install.sh: USER is not set" >&2
  exit 2
fi

install_packages() {
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed "${PACMAN_PACKAGES[@]}"
  else
    echo "skip    pacman not found"
  fi

  if command -v yay >/dev/null 2>&1; then
    yay -S --needed "${YAY_PACKAGES[@]}"
  else
    echo "skip    yay not found"
  fi
}

delete_broken_symlinks_in_path() {
  local dir="$1"
  local path="/"
  local part
  local rest="${dir#/}"

  while [ -n "$rest" ]; do
    part="${rest%%/*}"
    if [ "$rest" = "$part" ]; then
      rest=""
    else
      rest="${rest#*/}"
    fi

    if [ "$path" = "/" ]; then
      path="/$part"
    else
      path="$path/$part"
    fi

    if [ -L "$path" ] && [ ! -e "$path" ]; then
      printf 'delete  broken symlink %s -> %s\n' "$path" "$(readlink -- "$path")"
      rm -- "$path"
    fi
  done
}

link() {
  local rel="$1"
  local source="$ROOT/$rel"
  local target

  case "$rel" in
    home/USER/*)
      target="/home/$TARGET_USER/${rel#home/USER/}"
      ;;
    *)
      target="/$rel"
      ;;
  esac

  if [ ! -e "$source" ] && [ ! -L "$source" ]; then
    echo "missing $source" >&2
    exit 1
  fi

  if [ -L "$target" ] && [ ! -e "$target" ]; then
    printf 'delete  broken symlink %s -> %s\n' "$target" "$(readlink -- "$target")"
    rm -- "$target"
  fi

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

  delete_broken_symlinks_in_path "$(dirname -- "$target")"
  mkdir -p -- "$(dirname -- "$target")"
  printf 'link    %s -> %s\n' "$target" "$source"
  ln -s -- "$source" "$target"
}

install_packages

link "home/USER/.zshrc"
link "home/USER/.gitconfig"

link "home/USER/.config/Code/User/settings.json"
link "home/USER/.config/MangoHud/MangoHud.conf"
link "home/USER/.config/environment.d/electron.conf"
link "home/USER/.config/flameshot"
link "home/USER/.config/fuzzel"
link "home/USER/.config/ghostty"
link "home/USER/.config/gtk-2.0"
link "home/USER/.config/gtk-3.0"
link "home/USER/.config/gtk-4.0"
link "home/USER/.config/lazygit"
link "home/USER/.config/mako"
link "home/USER/.config/niri"
link "home/USER/.config/nvim"
link "home/USER/.config/obs-studio/basic/profiles"
link "home/USER/.config/swayidle"
link "home/USER/.config/swaylock"
link "home/USER/.config/tmux"
link "home/USER/.config/waybar"
link "home/USER/.config/witcher"
link "home/USER/.config/zed/keymap.json"
link "home/USER/.config/zed/settings.json"
link "home/USER/.config/zed/settings_backup.json"

link "home/USER/.icons/Polarnight-cursors"

link "home/USER/.local/bin/secure7z.sh"
link "home/USER/.local/share/applications/fuzzel-2fa.desktop"
link "home/USER/.local/share/applications/fuzzel-snippets.desktop"
link "home/USER/.local/share/backgrounds/bolduresti.png"
