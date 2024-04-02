export ZSH="$HOME/.oh-my-zsh/"

ZSH_THEME="powerlevel10k/powerlevel10k"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
export _JAVA_AWT_WM_NONREPARENTING=1


# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

source $ZSH/oh-my-zsh.sh
source $HOME/.p10k.zsh
source $HOME/.aliases
#path
export PATH="$PATH:/opt/flutter/bin"
export PATH="$PATH:bin"


# bun completions
[ -s "/home/shidox/.bun/_bun" ] && source "/home/shidox/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"

export PATH="$BUN_INSTALL/bin:$PATH"

# GOOGLE PATH FOR FLUTTER
alias google-chrome="google-chrome-stable"
