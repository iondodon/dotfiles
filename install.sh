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
  zsh
  python
  python-yaml
  tmux
  qt6-declarative
  qt6-5compat
  qt6-svg
  qt6-virtualkeyboard
  sddm
  niri
  waybar
  mako
  swaylock
  bluez
  blueman
  impala
  wiremix
  lazydocker
  lazygit
  ttf-nerd-fonts-symbols
  ttf-roboto
  flameshot
  ghostty
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
  fzf
  oath-toolkit
  libnotify
  grim
  pacman-contrib
  xwayland-satellite
  fastfetch
  onefetch
  7zip
)

AUR_PACKAGES=(
  ttf-jetbrains-mono
  yaru-gtk-theme
  outlook-for-linux
  brave-bin
)

PARU_REPO_URL="https://aur.archlinux.org/paru.git"
WITCHER_REPO_URL="https://github.com/iondodon/witcher.git"
OH_MY_ZSH_REPO_URL="https://github.com/ohmyzsh/ohmyzsh.git"
ZSH_AUTOSUGGESTIONS_REPO_URL="https://github.com/zsh-users/zsh-autosuggestions.git"
ZSH_SYNTAX_HIGHLIGHTING_REPO_URL="https://github.com/zsh-users/zsh-syntax-highlighting.git"
TPM_REPO_URL="https://github.com/tmux-plugins/tpm.git"
TMUX_BETTER_MOUSE_MODE_REPO_URL="https://github.com/NHDaly/tmux-better-mouse-mode.git"
TMUX_PREFIX_HIGHLIGHT_REPO_URL="https://github.com/tmux-plugins/tmux-prefix-highlight.git"

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

ensure_git() {
  if command -v git >/dev/null 2>&1; then
    return
  fi

  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed git
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
    sudo pacman -S --needed rust
  else
    echo "install.sh: cargo is required to install witcher" >&2
    exit 1
  fi
}

paru_works() {
  command -v paru >/dev/null 2>&1 && paru --version >/dev/null 2>&1
}

clone_install_repo() {
  mkdir -p -- "$(dirname -- "$INSTALL_DIR")"
  git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$INSTALL_DIR"
}

backup_install_repo() {
  local reason="$1"
  local backup_dir

  backup_dir="$INSTALL_DIR.$reason.$(date +%Y%m%d%H%M%S)"
  printf 'backup  %s -> %s\n' "$INSTALL_DIR" "$backup_dir"
  mv -- "$INSTALL_DIR" "$backup_dir"
}

bootstrap_repo() {
  if [ -n "$ROOT" ] && [ -f "$ROOT/install.sh" ] && [ -e "$ROOT/home/USER/.zshrc" ]; then
    return
  fi

  ensure_git

  if [ -e "$INSTALL_DIR" ]; then
    local status_output

    if [ ! -d "$INSTALL_DIR/.git" ]; then
      echo "install.sh: $INSTALL_DIR exists and is not a git repository" >&2
      exit 1
    fi

    if ! status_output="$(git -C "$INSTALL_DIR" status --porcelain 2>/dev/null)"; then
      backup_install_repo "corrupt"
      clone_install_repo
      exec bash "$INSTALL_DIR/install.sh"
    fi

    if [ -n "$status_output" ]; then
      echo "install.sh: $INSTALL_DIR has uncommitted changes; commit, stash, or remove them before updating" >&2
      exit 1
    fi

    if ! git -C "$INSTALL_DIR" fetch --depth 1 origin "+refs/heads/$BRANCH:refs/remotes/origin/$BRANCH"; then
      if ! git -C "$INSTALL_DIR" fsck --no-progress >/dev/null 2>&1; then
        backup_install_repo "corrupt"
        clone_install_repo
        exec bash "$INSTALL_DIR/install.sh"
      fi

      echo "install.sh: failed to update $INSTALL_DIR" >&2
      exit 1
    fi

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
    clone_install_repo
  fi

  exec bash "$INSTALL_DIR/install.sh"
}

bootstrap_repo

install_paru() {
  if paru_works; then
    return
  fi

  if ! command -v pacman >/dev/null 2>&1; then
    echo "skip    paru install requires pacman"
    return
  fi

  ensure_cargo

  local build_dir
  build_dir="$(mktemp -d)"

  (
    trap 'rm -rf -- "$build_dir"' EXIT
    sudo pacman -Syu --needed git base-devel
    git clone --depth 1 "$PARU_REPO_URL" "$build_dir/paru"
    cd "$build_dir/paru"
    makepkg -si --needed
  )

  if ! paru_works; then
    echo "install.sh: paru installed, but paru cannot run" >&2
    exit 1
  fi
}

install_packages() {
  if command -v pacman >/dev/null 2>&1; then
    sudo pacman -Syu --needed "${PACMAN_PACKAGES[@]}"
  else
    echo "skip    pacman not found"
  fi

  install_paru

  if paru_works; then
    paru -S --needed "${AUR_PACKAGES[@]}"
  else
    echo "skip    paru not found"
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

clone_or_update_repo() {
  local repo_url="$1"
  local target_dir="$2"

  ensure_git

  if [ -d "$target_dir/.git" ]; then
    printf 'update  %s\n' "$target_dir"
    git -C "$target_dir" pull --ff-only
    return
  fi

  if [ -e "$target_dir" ]; then
    printf 'skip    %s exists and is not a git repository\n' "$target_dir"
    return
  fi

  printf 'clone   %s\n' "$target_dir"
  git clone --depth 1 "$repo_url" "$target_dir"
}

install_oh_my_zsh() {
  local zsh_dir="$HOME/.oh-my-zsh"
  local custom_dir="${ZSH_CUSTOM:-$zsh_dir/custom}"

  clone_or_update_repo "$OH_MY_ZSH_REPO_URL" "$zsh_dir"
  mkdir -p -- "$custom_dir/plugins"
  clone_or_update_repo "$ZSH_AUTOSUGGESTIONS_REPO_URL" "$custom_dir/plugins/zsh-autosuggestions"
  clone_or_update_repo "$ZSH_SYNTAX_HIGHLIGHTING_REPO_URL" "$custom_dir/plugins/zsh-syntax-highlighting"
}

install_tmux_plugins() {
  local plugins_dir="$HOME/.tmux/plugins"

  mkdir -p -- "$plugins_dir"
  clone_or_update_repo "$TPM_REPO_URL" "$plugins_dir/tpm"
  clone_or_update_repo "$TMUX_BETTER_MOUSE_MODE_REPO_URL" "$plugins_dir/tmux-better-mouse-mode"
  clone_or_update_repo "$TMUX_PREFIX_HIGHLIGHT_REPO_URL" "$plugins_dir/tmux-prefix-highlight"
}

enable_systemd_service() {
  local service="$1"

  if ! command -v systemctl >/dev/null 2>&1; then
    echo "skip    systemctl not found"
    return
  fi

  if systemctl is-enabled --quiet "$service"; then
    printf 'exists  %s enabled\n' "$service"
  else
    printf 'enable  %s\n' "$service"
    sudo systemctl enable "$service" || {
      printf 'install.sh: failed to enable %s\n' "$service" >&2
      exit 1
    }
  fi
}

set_display_manager() {
  local service="$1"
  local display_manager_path
  local service_path

  if ! command -v systemctl >/dev/null 2>&1; then
    echo "skip    systemctl not found"
    return
  fi

  display_manager_path="$(readlink -f /etc/systemd/system/display-manager.service 2>/dev/null || true)"
  service_path="$(systemctl show -P FragmentPath "$service" 2>/dev/null || true)"

  if [ -n "$display_manager_path" ] && [ "$display_manager_path" = "$service_path" ]; then
    printf 'exists  display manager %s\n' "$service"
    return
  fi

  printf 'display %s\n' "$service"
  sudo systemctl enable --force "$service" || {
    printf 'install.sh: failed to set %s as display manager\n' "$service" >&2
    exit 1
  }
}

start_systemd_service() {
  local service="$1"

  if ! command -v systemctl >/dev/null 2>&1; then
    echo "skip    systemctl not found"
    return
  fi

  if systemctl is-active --quiet "$service"; then
    printf 'exists  %s active\n' "$service"
  else
    printf 'start   %s\n' "$service"
    sudo systemctl start "$service" || {
      printf 'install.sh: failed to start %s\n' "$service" >&2
      exit 1
    }
  fi
}

setup_system_services() {
  set_display_manager sddm.service
  enable_systemd_service bluetooth.service
  start_systemd_service bluetooth.service
}

set_gnome_interface_settings() {
  if ! command -v gsettings >/dev/null 2>&1; then
    echo "skip    gsettings not found"
    return
  fi

  echo "setting GNOME interface dark mode"
  gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
  gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
}

set_default_shell() {
  local zsh_path
  local current_shell

  if ! zsh_path="$(command -v zsh)"; then
    echo "skip    zsh not found"
    return
  fi

  if ! grep -Fxq "$zsh_path" /etc/shells; then
    if grep -Fxq /bin/zsh /etc/shells; then
      zsh_path="/bin/zsh"
    else
      echo "skip    $zsh_path is not listed in /etc/shells"
      return
    fi
  fi

  current_shell="$(getent passwd "$TARGET_USER" | cut -d: -f7)"
  if [ "$current_shell" = "$zsh_path" ]; then
    printf 'exists  default shell %s\n' "$zsh_path"
    return
  fi

  printf 'shell   %s -> %s\n' "$TARGET_USER" "$zsh_path"
  chsh -s "$zsh_path" "$TARGET_USER"
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

link_group() {
  local rel
  local source
  local target
  local conflicting_targets=()

  for rel in "$@"; do
    source="$ROOT/$rel"

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

    if [ -e "$target" ] || [ -L "$target" ]; then
      if [ "$(readlink -- "$target" || true)" != "$source" ]; then
        conflicting_targets+=("$target")
      fi
    fi
  done

  if [ "${#conflicting_targets[@]}" -gt 0 ]; then
    echo "override link targets?"
    for target in "${conflicting_targets[@]}"; do
      printf '  %s\n' "$target"
    done

    if read -r -p "[y/N] " answer && [[ "$answer" =~ ^[Yy]$ ]]; then
      for target in "${conflicting_targets[@]}"; do
        rm -rf -- "$target"
      done
    else
      echo "skip    link target group"
      return
    fi
  fi

  for rel in "$@"; do
    link "$rel"
  done
}

install_system() {
  local rel="$1"
  local source="$ROOT/$rel"
  local target="/$rel"

  if [ ! -e "$source" ] && [ ! -L "$source" ]; then
    echo "missing $source" >&2
    exit 1
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    if read -r -p "override $target? [y/N] " answer && [[ "$answer" =~ ^[Yy]$ ]]; then
      sudo rm -rf -- "$target"
    else
      printf 'skip    %s exists\n' "$target"
      return
    fi
  fi

  sudo mkdir -p -- "$(dirname -- "$target")"
  printf 'install %s -> %s\n' "$source" "$target"
  sudo cp -a -- "$source" "$target"
  sudo chown -R root:root "$target"
  if [ -d "$target" ]; then
    sudo find "$target" -type d -exec chmod 755 {} +
    sudo find "$target" -type f -exec chmod 644 {} +
  else
    sudo chmod 644 "$target"
  fi
}

install_system_group() {
  local rel
  local source
  local target
  local existing_targets=()

  for rel in "$@"; do
    source="$ROOT/$rel"
    target="/$rel"

    if [ ! -e "$source" ] && [ ! -L "$source" ]; then
      echo "missing $source" >&2
      exit 1
    fi

    if [ -e "$target" ] || [ -L "$target" ]; then
      existing_targets+=("$target")
    fi
  done

  if [ "${#existing_targets[@]}" -gt 0 ]; then
    echo "override system paths?"
    for target in "${existing_targets[@]}"; do
      printf '  %s\n' "$target"
    done

    if read -r -p "[y/N] " answer && [[ "$answer" =~ ^[Yy]$ ]]; then
      for target in "${existing_targets[@]}"; do
        sudo rm -rf -- "$target"
      done
    else
      echo "skip    system path group"
      return
    fi
  fi

  for rel in "$@"; do
    install_system "$rel"
  done
}

install_packages
install_witcher
install_oh_my_zsh
install_tmux_plugins
setup_system_services
set_gnome_interface_settings
set_default_shell

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
link_group \
  "home/USER/.local/share/applications/fuzzel-2fa.desktop" \
  "home/USER/.local/share/applications/fuzzel-snippets.desktop"
link "home/USER/.local/share/backgrounds/bolduresti.png"

install_system_group \
  "etc/sddm.conf.d/theme.conf" \
  "usr/share/sddm/themes/sddm-slice"
