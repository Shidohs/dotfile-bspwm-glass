# Exports
export ZSH="$HOME/.oh-my-zsh/"
export _JAVA_AWT_WM_NONREPARENTING=1
export BUN_INSTALL="$HOME/.bun"
export NVM_DIR="$HOME/.nvm"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# History
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Plugins
plugins=(
  fzf
  fzf-tab
  sudo
  bgnotify
  zsh-syntax-highlighting
  zsh-autosuggestions
  git
  command-not-found
)

#Source
source $ZSH/oh-my-zsh.sh
source $HOME/.p10k.zsh
source $HOME/.aliases

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

# bun completions
[ -s "/home/shidox/.bun/_bun" ] && source "/home/shidox/.bun/_bun"

# Path
export PATH="$PATH:/opt/flutter/bin"
export PATH="$PATH:bin"
export PATH="$BUN_INSTALL/bin:$PATH"
PATH=~/.console-ninja/.bin:$PATH


#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
