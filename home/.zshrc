##########################################################
# 1. Variables de Entorno y PATHs
##########################################################
# Java (solución para gestores de ventanas sin reparenting)
export _JAVA_AWT_WM_NONREPARENTING=1


# Modificaciones de PATH
export PATH="$HOME/.local/bin:$HOME/bin:/var/lib/snapd/snap/bin:$PATH"
export PATH=$PATH:/var/lib/snapd/snap/bin


# Rutas del Android SDK

export ANDROID_SDK_ROOT=$HOME/Android/Sdk
export PATH=$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$PATH
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$PATH"



# Configuración del entorno de escritorio
export XDG_CURRENT_DESKTOP=bspwm
export XDG_MENU_PREFIX=""

##########################################################
# 2. Configuración del Historial
##########################################################
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$HOME/.zsh_history"

##########################################################
# 3. Inicialización de Zsh
##########################################################
autoload -U compinit && compinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

##########################################################
# 4. Configuraciones Personalizadas y Fuentes
##########################################################
source "$HOME/.p10k.zsh"
source "$HOME/.aliases"
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

##########################################################
# 5. Instalación y Configuración de Zinit
##########################################################
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    print -P "%F{33} Instalando ZDHARMA-CONTINUUM Zinit...%f"
    mkdir -p "$HOME/.local/share/zinit" && chmod g-rwX "$HOME/.local/share/zinit"
    git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{34} Instalación exitosa.%f" || \
        print -P "%F{160} Fallo en la instalación.%f"
fi

# Cargar annexes de Zinit
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

##########################################################
# 6. Temas y Plugins con Zinit
##########################################################
zinit ice depth=1; zinit light romkatv/powerlevel10k

zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit light darvid/zsh-poetry
zinit snippet OMZP::bgnotify

##########################################################
# 7. Configuración de fzf
##########################################################
source <(fzf --zsh)

# Configuración de fzf-tab
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

##########################################################
# 8. Arreglo de Teclas de Atajo
##########################################################
bindkey "^[[H" beginning-of-line   # Tecla Inicio
bindkey "^[[F" end-of-line         # Tecla Fin
bindkey "^[[3~" delete-char        # Tecla Supr
bindkey "^[[2~" overwrite-mode     # Tecla Insert


[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
