# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export _JAVA_AWT_WM_NONREPARENTING=1

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"



# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

function man() {
  env \
    LESS_TERMCAP_mb=$'\e[01;31m' \
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    man "$@"
}



function fzf-lovely() {
  if [ "$1" = "h" ]; then
    fzf -m --reverse --preview-window down:20 --preview '[[ $(file --mime {}) =~ binary ]] &&
                  echo {} is a binary file ||
                   (bat --style=numbers --color=always {} ||
                    highlight -O ansi -l {} ||
                    coderay {} ||
                    rougify {} ||
                    cat {}) 2> /dev/null | head -500'
  else
    fzf -m --preview '[[ $(file --mime {}) =~ binary ]] &&
                         echo {} is a binary file ||
                         (bat --style=numbers --color=always {} ||
                          highlight -O ansi -l {} ||
                          coderay {} ||
                          rougify {} ||
                          cat {}) 2> /dev/null | head -500'
  fi
}

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
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Aliases ##

# General
alias c="clear"
alias q="exit"
alias hd="hexdump -C"
alias nanosu="sudo nano"
alias vimsu="sudo vim"
alias nvimsu="sudo nvim"

# System Maintenance
alias pacrem="sudo pacman -Rcns"
alias yayupd="yay -Sy"
alias yayupg="yay -Syu"
alias trimall="sudo fstrim -va"
alias reflesh="sudo reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist"

# Package Management (Pacman)
alias pcs="sudo pacman -S"
alias pcr="sudo pacman -R"
alias pcrs="sudo pacman -Rs"
alias pcsyu="sudo pacman -Syu"
alias grub-update="sudo grub-mkconfig -o /boot/grub/grub.cfg"
alias mantenimiento="yay -Sc && sudo pacman -Scc"
alias purga="sudo pacman -Rns $(pacman -Qtdq) ; sudo fstrim -av"
alias update="yay -Syu"

# Shortcuts
alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="thunar ~/.oh-my-zsh"

# LS Aliases

alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
#alias ls='lsd'
alias cat='bat'


#path
export PATH="$PATH:/opt/flutter/bin"
export PATH="$PATH:bin"

