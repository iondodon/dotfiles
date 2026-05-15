#!/usr/bin/env bash
set -euo pipefail

SCRIPT_PATH="${BASH_SOURCE[0]:-$0}"
if [ -f "$SCRIPT_PATH" ]; then
  ROOT="$(cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"
else
  ROOT=""
fi
TARGET_USER="${USER:-}"
REPO_URL="${DOTFILES_REPO_URL:-https://github.com/iondodon/dotfiles.git}"
BRANCH="${DOTFILES_BRANCH:-main}"
INSTALL_DIR="${DOTFILES_INSTALL_DIR:-${HOME:-}/dotfiles}"

PACMAN_PACKAGES=(
  git
  base-devel
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
  brave-bin
)

YAY_REPO_URL="https://aur.archlinux.org/yay.git"
WITCHER_REPO_URL="https://github.com/iondodon/witcher.git"

if [ -z "${HOME:-}" ]; then
  echo "install.sh: HOME is not set" >&2
  exit 2
fi

if [ -z "$TARGET_USER" ]; then
  echo "install.sh: USER is not set" >&2
  exit 2
fi

if [ "$(id -u)" -eq 0 ]; then
  echo "install.sh: run this script as your home user, not as root or with sudo" >&2
  exit 2
fi

pacman_failed() {
  cat >&2 <<'EOF'
install.sh: pacman failed.

This is often caused by a stale or broken Arch mirror. Refresh your mirrors, then
run the installer again:

  sudo pacman -Syyu

If pacman reports a specific bad mirror, comment it out, remove it, or move it
lower in:

  /etc/pacman.d/mirrorlist

Then refresh package databases again:

  sudo pacman -Syyu

If reflector is installed, you can regenerate the mirror list with:

  sudo reflector --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
  sudo pacman -Syyu
EOF
}

pacman_install() {
  sudo pacman -S --needed "$@" || {
    pacman_failed
    exit 1
  }
}

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    pacman_install git
  else
    echo "install.sh: git is required" >&2
    exit 1
  fi
}

ensure_cargo() {
  if command -v cargo >/dev/null 2>&1; then
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    pacman_install rust
  else
    echo "install.sh: cargo is required to install witcher" >&2
    exit 1
  fi
}

bootstrap_repo() {
  if [ -n "$ROOT" ] && [ -f "$ROOT/install.sh" ] && [ -e "$ROOT/home/USER/.zshrc" ]; then
    return
  fi

  ensure_git

  if [ -e "$INSTALL_DIR" ]; then
    if [ ! -d "$INSTALL_DIR/.git" ]; then
      echo "install.sh: $INSTALL_DIR exists and is not a git repository" >&2
      exit 1
    fi

    if [ -n "$(git -C "$INSTALL_DIR" status --porcelain)" ]; then
      echo "install.sh: $INSTALL_DIR has uncommitted changes; commit, stash, or remove them before updating" >&2
      exit 1
    fi

    git -C "$INSTALL_DIR" fetch --depth 1 origin "+refs/heads/$BRANCH:refs/remotes/origin/$BRANCH"

    local current_head
    local remote_head
    current_head="$(git -C "$INSTALL_DIR" rev-parse --verify HEAD 2>/dev/null || true)"
    remote_head="$(git -C "$INSTALL_DIR" rev-parse --verify "origin/$BRANCH")"

    if [ -n "$current_head" ] && [ "$current_head" != "$remote_head" ] && ! git -C "$INSTALL_DIR" merge-base --is-ancestor "$current_head" "origin/$BRANCH"; then
      local backup_branch
      backup_branch="backup/$BRANCH-$(date +%Y%m%d%H%M%S)"
      git -C "$INSTALL_DIR" branch "$backup_branch" "$current_head"
      echo "backup  saved previous $BRANCH as $backup_branch"
    fi

    git -C "$INSTALL_DIR" checkout -B "$BRANCH" "origin/$BRANCH"
  else
    mkdir -p -- "$(dirname -- "$INSTALL_DIR")"
    git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
  fi

  exec bash "$INSTALL_DIR/install.sh"
}

bootstrap_repo

install_yay() {
  if command -v yay >/dev/null 2>&1; then
    return
  fi

  if ! command -v pacman >/dev/null 2>&1; then
    echo "skip    yay install requires pacman"
    return
  fi

  local build_dir
  build_dir="$(mktemp -d)"

  (
    trap 'rm -rf -- "$build_dir"' EXIT
    pacman_install git base-devel
    git clone --depth 1 "$YAY_REPO_URL" "$build_dir/yay"
    cd "$build_dir/yay"
    makepkg -si --needed
  )
}

install_packages() {
  if command -v pacman >/dev/null 2>&1; then
    pacman_install "${PACMAN_PACKAGES[@]}"
  else
    echo "skip    pacman not found"
  fi

  install_yay

  if command -v yay >/dev/null 2>&1; then
    yay -S --needed "${YAY_PACKAGES[@]}"
  else
    echo "skip    yay not found"
  fi
}

install_witcher() {
  local cargo_home="${CARGO_HOME:-$HOME/.cargo}"

  if command -v witcher >/dev/null 2>&1 || [ -x "$cargo_home/bin/witcher" ]; then
    echo "exists  witcher"
    return
  fi

  ensure_git
  ensure_cargo

  local build_dir
  build_dir="$(mktemp -d)"

  (
    trap 'rm -rf -- "$build_dir"' EXIT
    git clone --depth 1 "$WITCHER_REPO_URL" "$build_dir/witcher"
    cd "$build_dir/witcher"
    cargo install --path .
  )
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
install_witcher

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
