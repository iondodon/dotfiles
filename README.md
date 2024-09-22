### Install

```bash
sudo apt install awesome zenity rofi ulauncher pavucontrol qasmixer blueman pm-utils brightnessctl compton nitrogen network-manager-gnome
```

```bash
npm install -g @microsoft/inshellisense
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
cargo install --locked zellij
```

- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [fzf](https://github.com/junegunn/fzf)
- [oh-my-bash](https://github.com/ohmybash/oh-my-bash)

### Clone for new machine

```bash
git init
git remote add origin git@github.com:iondodon/dotfiles.git
git fetch origin
git reset --hard origin/main
git clean -fd
```
