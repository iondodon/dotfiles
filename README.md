The dotfiles are managed by GNU `stow`. Before creating the symlinks perform a sanity check: `stow -nvt ~ .` From the `dotfiles` directory perform: `stow -t ~ .` to create the symlinks.

## Debian based

```bash
sudo apt install stow awesome pavucontrol blueman pm-utils brightnessctl network-manager-gnome xprintidle xdotool arandr pasystray simplescreenrecorder pulseaudio-utils redshift flameshot fonts-jetbrains-mono wl-clipboard yaru-theme-gtk sddm shellcheck
```

## Arch based

```bash
sudo pacman -S stow sddm niri hyprland awesome waybar picom mako swaylock blueman ttf-nerd-fonts-symbols flameshot rofi nautilus vicious redshift gammastep xclip xsel ttf-jetbrains-mono arandr wl-clipboard shellcheck swaybg network-manager-applet systemctl-tui caligula swayidle fuzzel grim pacman-contrib xwayland-satellite
```

```bash
yay -S ttf-jetbrains-mono fsearch yaru-gtk-theme outlook-for-linux swaylock-effects
```

## Sources

- [stow](https://www.gnu.org/software/stow/)
- [flameshot](https://github.com/flameshot-org/flameshot) - [flameshot.org](https://flameshot.org/)
- [fireshot](https://github.com/iondodon/fireshot) - `cargo install --path crates/app` from root directory
- [picom](https://github.com/yshui/picom) - for debian build from source, for arch install with pacman
- [xwitcher](https://github.com/iondodon/xwitcher) - `cargo install --path .`
- [witcher](https://github.com/iondodon/witcher) - `cargo install --path .`
- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [rofi](https://github.com/davatorium/rofi) - build newest from source
- [lazydocker](https://github.com/jesseduffield/lazydocker)
- [lazygit](https://github.com/jesseduffield/lazygit)
- [dictate](https://github.com/iondodon/dictate)
- [onefetch](https://github.com/o2sh/onefetch)
- [waybar](https://github.com/Alexays/Waybar)
- [niri](https://github.com/YaLTeR/niri)
- [hyprland](https://github.com/hyprwm/Hyprland) - [hypr.land/](https://hypr.land/)
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

<br>

- [zellij](https://github.com/zellij-org/zellij)
- [tpm](https://github.com/tmux-plugins/tpm) - install to use it to install tmux plugins
- [tmux](https://github.com/tmux/tmux) - install latest version from source. Use [tpm](https://github.com/tmux-plugins/tpm) plugin to install other plugins - `prefix+b I` to install the plugins defined in `tmux.conf`.
- [tmux-better-mouse-mode](https://github.com/NHDaly/tmux-better-mouse-mode)
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

---

#### rofi

In `combi` mode, type `!mode` (example: `!2fa Google`) to active a mode.

Install dependencies for the custom modes: `pip install pyotp pyyaml`

Check the mode scripts for any other dependencies.

For the `2fa` mode rename the 2fa.yml.example to 2fa.yml in ~/.config/rofi. The 2fa.yml file will be ignored in dotfiles .gitignore for pretection.

Use `-no-lazy-grab` to make rofi appear quicker.

#### fuzzel

2FA mode (~/.config/fuzzel/2fa.py)

- Required: python3, fuzzel, pyyaml, oathtool
- Clipboard: wl-clipboard (wl-copy) preferred; fallback xclip or xsel
- Notifications: notify-send (from libnotify)

Snippets mode (~/.config/fuzzel/snippets.py)

- Required: python3, fuzzel, pyyaml
- Clipboard: wl-clipboard (wl-copy) preferred; fallback xclip or xsel
- Notifications: notify-send (from libnotify)

#### redshift

`redshift -l 47.0036:28.9070 -t 6000:5000 -g 1.0:1.0:1.0 -m randr`

`redshift -x` - back to defaults

#### InteliJ IDEA

In wayland add this VM option `-Dawt.toolkit.name=WLToolkit` in `Help -> About -> Edit Custom VM Options`: https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/

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
