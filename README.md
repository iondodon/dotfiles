## Install

```bash
bash -c "$(curl -LfsS https://github.com/iondodon/dotfiles/raw/main/install.sh)"
```

Run the installer as your normal home user. The script refuses to run as root or with `sudo`; it uses `sudo` internally only where package installation needs it.

The installer clones and updates this repo as a shallow checkout with `--depth 1`. Local history is intentionally limited to the latest fetched commit, so commands such as `git log`, parent lookup, or child lookup only see the commits available in that shallow clone.

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
- [sddm-slice](https://github.com/EricKotato/sddm-slice) - vendored under `usr/share/sddm/themes/sddm-slice` and configured for Arch's Qt6 SDDM greeter
- [brave-browser](https://brave.com)
- [qbittorrent](https://www.qbittorrent.org/)
- [impala](https://github.com/pythops/impala)
- [wiremix](https://github.com/tsowell/wiremix)
- [systemctl-tui](https://github.com/rgwood/systemctl-tui)
- [7zip](https://github.com/ip7z/7zip)
- [Mangohud](https://github.com/flightlessmango/Mangohud)
- [LACT](https://github.com/ilya-zlobintsev/LACT)

<br>

- [tpm](https://github.com/tmux-plugins/tpm) - installed by `install.sh` into `~/.tmux/plugins/tpm`
- [tmux](https://github.com/tmux/tmux) - installed from Arch packages. The installer clones the tmux plugins used by `tmux.conf`.
- [tmux-better-mouse-mode](https://github.com/NHDaly/tmux-better-mouse-mode)
- [alacritty](https://github.com/alacritty/alacritty) - [https://alacritty.org/](https://alacritty.org/)
- [ghostty](https://ghostty.org/)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh) - [https://ohmyz.sh](https://ohmyz.sh)
- [fzf](https://github.com/junegunn/fzf)
- [inshellisense](https://github.com/microsoft/inshellisense)
- [jwt-cli](https://github.com/mike-engel/jwt-cli)
- [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
- [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting)
- [shellcheck](https://github.com/koalaman/shellcheck)

<br>

- [just](https://github.com/casey/just)
- [vscode-restclient](https://github.com/Huachao/vscode-restclient)

---

#### VSCode

Extensions: mhutchie.git-graph, humao.rest-client, cordx56.rustowl-vscode
