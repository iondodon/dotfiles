### Install

```bash
sudo apt install \
	awesome \
	zenity \
	rofi \
	ulauncher \
	pavucontrol \
	qasmixer \
	blueman \
	pm-utils \
	brightnessctl \
	compton \
	nitrogen \
	network-manager-gnome \
	xprintidle \
	xdotool \
	arandr \
	pasystray \
	simplescreenrecorder \
	pulseaudio-utils \
	kdocker \
	alltray
```

```bash
npm install -g @microsoft/inshellisense
cargo install --locked zellij
```

- [kitty](https://sw.kovidgoyal.net/kitty/) [install](https://sw.kovidgoyal.net/kitty/binary/) `sudo ln -s ~/.local/kitty.app/bin/kitty ~/.local/bin`
- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [fzf](https://github.com/junegunn/fzf)
- [oh-my-bash](https://github.com/ohmybash/oh-my-bash)
- [snipline](https://snipline.io)
- [ulauncher-snippets](https://github.com/mikebarkmin/ulauncher-snippets)
- [ulauncher-2fa](https://github.com/martindiphoorn/ulauncher-2fa)
- [lazydocker](https://github.com/jesseduffield/lazydocker)

### VS Code

```json
// Place your key bindings in this file to override the defaults
// https://samedwardes.com/blog/2023-06-11-vscode-bash-to-terminal/
// Open the command pallet using cmd + shift + p.
// Type Preferences: Open Keyboard Shortcuts (JSON)
// Then edit the keybindings.json file:

[
  {
    "key": "shift+enter",
    "command": "workbench.action.terminal.runSelectedText",
    "when": "editorTextFocus && !findInputFocussed && !replaceInputFocussed && editorLangId == 'shellscript'"
  }
]
```


### ulauncher
`sudo pip install python-frontmatter --break-system-packages`
`sudo apt install python3-onetimepass`
`echo 'greenclip daemon &' >> ~/.xprofile` then  `sudo chmod +x greenclip` for [https://github.com/iondodon/ulauncher-greenclip](https://github.com/iondodon/ulauncher-greenclip)

### Clone for new machine

```bash
git init
git remote add origin git@github.com:iondodon/dotfiles.git
git fetch origin
git reset --hard origin/main
git clean -fd
```
