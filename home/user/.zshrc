# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

#######################################
# User configuration ##################
#######################################

export EDITOR=nano
export VISUAL=nano
export SUDO_EDITOR=nano

# Secrets
if [ -f "$HOME/.secrets" ]; then
    source "$HOME/.secrets"
fi

# Go binaries (go install)
if [[ -d "$HOME/go/bin" ]]; then
  export PATH="$PATH:$HOME/go/bin"
fi

if [ -d "$HOME/zig-x86_64-linux-0.14.1" ]; then
    export PATH=$PATH:$HOME/zig-x86_64-linux-0.14.1
fi

if [ -d "$HOME/.sdkman/candidates/maven/3.9.8/bin" ]; then
    export PATH=$PATH:$HOME/.sdkman/candidates/maven/3.9.8/bin
fi

if [ -d "$HOME/.nvm" ]; then
   export NVM_DIR="$HOME/.nvm"
   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

if [ -d "$HOME/.cargo/bin" ]; then
   export PATH=$PATH:$HOME/.cargo/bin
fi

if [ -d "$HOME/.cargo/env" ]; then
   source "$HOME/.cargo/env"
fi

if [ -d "$HOME/.sdkman" ]; then
   # ??? THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!! ???
   export SDKMAN_DIR="$HOME/.sdkman"
   [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
   export PATH=$HOME/.local/bin:$PATH
fi

if [[ -d "$HOME/.local/bin" ]]; then
   export PATH="$HOME/.local/bin:$PATH"
fi

if [ -f /usr/share/fzf/key-bindings.zsh ]; then
   source /usr/share/fzf/key-bindings.zsh
fi

if [ -f /usr/share/fzf/completion.zsh ]; then
   source /usr/share/fzf/completion.zsh
elif [ -f "$HOME/.fzf.zsh" ]; then
   source "$HOME/.fzf.zsh"
fi

if [ -d "$HOME/flutter/bin" ]; then
   export PATH=$HOME/flutter/bin:$PATH
   export FLUTTER_GIT_URL="" # to fix and issues with hagging flutter command - to be removed
fi

autoload -U add-zsh-hook

LAST_ONEFETCH_ROOT=""

run_onefetch() {
  local root

  if ! root=$(git rev-parse --show-toplevel 2>/dev/null); then
    LAST_ONEFETCH_ROOT=""
    return
  fi

  if [[ "$root" != "$LAST_ONEFETCH_ROOT" ]]; then
    LAST_ONEFETCH_ROOT="$root"
    onefetch
  fi
}

fastfetch

add-zsh-hook chpwd run_onefetch
run_onefetch
