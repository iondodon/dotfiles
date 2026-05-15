The repository mirrors the real filesystem layout:

- `home/USER/...` maps to `/home/$USER/...`
- `etc/...` maps to `/etc/...`

Install packages and create the symlinks listed in `install.sh` with one command:

```bash
bash -c "$(curl -LfsS https://github.com/iondodon/dotfiles/raw/main/install.sh)"
```

When run from curl, `install.sh` clones or updates the repository at `~/dotfiles`, then runs the local copy from there.

The installer uses the current `$USER` for the `home/USER` placeholder. Some entries map individual files, while self-contained config folders can be mapped as directories. Existing targets are confirmed before replacement.

Run the installer as your normal home user. The script refuses to run as root or with `sudo`; it uses `sudo` internally only where package installation needs it.

If Pacman fails to download packages from a broken mirror, comment out, remove, or move that mirror lower in `/etc/pacman.d/mirrorlist`. Then refresh package databases and rerun the installer:

```bash
sudo pacman -Syyu
```

If `reflector` is installed:

```bash
sudo reflector --protocol https --latest 20 --sort rate --save /etc/pacman.d/mirrorlist
sudo pacman -Syyu
```

## Arch based packages

```bash
sudo pacman -S git base-devel sddm niri waybar mako swaylock blueman ttf-nerd-fonts-symbols flameshot nautilus vicious gammastep xclip xsel ttf-jetbrains-mono arandr wl-clipboard shellcheck swaybg network-manager-applet systemctl-tui caligula swayidle fuzzel grim pacman-contrib xwayland-satellite fastfetch 7zip
```

If `yay` is not installed yet:

```bash
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si
```

```bash
yay -S ttf-jetbrains-mono fsearch yaru-gtk-theme outlook-for-linux
```

## Sources

- [flameshot](https://github.com/flameshot-org/flameshot) - [flameshot.org](https://flameshot.org/)
- [fireshot](https://github.com/iondodon/fireshot) - `cargo install --path crates/app` from root directory
- [witcher](https://github.com/iondodon/witcher) - `cargo install --path .`
- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [lazydocker](https://github.com/jesseduffield/lazydocker)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [onefetch](https://github.com/o2sh/onefetch)
- [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [waybar](https://github.com/Alexays/Waybar)
- [niri](https://github.com/niri-wm/niri) - [https://niri-wm.github.io/niri/](https://niri-wm.github.io/niri/)
- [fsearch](https://github.com/cboxdoerfer/fsearch)
- [brave-browser](https://brave.com)
- [min](https://github.com/minbrowser/min) - [minbrowser.org](https://minbrowser.org/)
- [qbittorrent](https://www.qbittorrent.org/)
- [mechvibes-dx](https://github.com/hainguyents13/mechvibes-dx) - `cargo install --path .`
- [localsend](https://github.com/localsend/localsend) - [localsend.org](https://localsend.org/)
- [impala](https://github.com/pythops/impala)
- [wiremix](https://github.com/tsowell/wiremix)
- [fresh](https://github.com/sinelaw/fresh)
- [systemctl-tui](https://github.com/rgwood/systemctl-tui)
- [Kooha](https://github.com/SeaDve/Kooha)
- [caligula](https://github.com/ifd3f/caligula)
- [obsidian](https://obsidian.md/)
- [7zip](https://github.com/ip7z/7zip)
- [Mangohud](https://github.com/flightlessmango/Mangohud)
- [LACT](https://github.com/ilya-zlobintsev/LACT)

<br>

- [tpm](https://github.com/tmux-plugins/tpm) - install to use it to install tmux plugins
- [tmux](https://github.com/tmux/tmux) - install latest version from source. Use [tpm](https://github.com/tmux-plugins/tpm) plugin to install other plugins - `prefix+b I` to install the plugins defined in `tmux.conf`.
- [tmux-better-mouse-mode](https://github.com/NHDaly/tmux-better-mouse-mode)
- [alacritty](https://github.com/alacritty/alacritty) - [https://alacritty.org/](https://alacritty.org/)
- [ghostty](https://ghostty.org/)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) - [https://ohmyz.sh](https://ohmyz.sh)
- List all available shells: `cat /etc/shells`
- Set the default shell: `chsh -s /bin/zsh`
- [fzf](https://github.com/junegunn/fzf)
- [inshellisense](https://github.com/microsoft/inshellisense)
- [jwt-cli](https://github.com/mike-engel/jwt-cli)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [shellcheck](https://github.com/koalaman/shellcheck)

<br>

- [just](https://github.com/casey/just)
- [vscode-restclient](https://github.com/Huachao/vscode-restclient)
- [httpyac](https://github.com/anweber/httpyac) - [httpyac.github.io](https://httpyac.github.io/)

---

#### fuzzel

2FA mode (~/.config/fuzzel/2fa.py)

- Required: python3, fuzzel, pyyaml, oathtool
- Clipboard: wl-clipboard (wl-copy) preferred; fallback xclip or xsel
- Notifications: notify-send (from libnotify)

Snippets mode (~/.config/fuzzel/snippets.py)

- Required: python3, fuzzel, pyyaml
- Clipboard: wl-clipboard (wl-copy) preferred; fallback xclip or xsel
- Notifications: notify-send (from libnotify)

#### Zed

[java](https://github.com/zed-extensions/java)

#### blueman

```sh
sudo systemctl enable bluetooth
sudo systemctl start bluetooth
```

#### VSCode

Extensions: mhutchie.git-graph, humao.rest-client, cordx56.rustowl-vscode

#### GNOME interface theme

GNOME apps (e.g., Nautilus/System Monitor) read theme and color-scheme from dconf, not GTK ini files. Set dark mode with:

```sh
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
```

#### Flameshot

On Wayland needs `grim` to be installed.
