#!/usr/bin/env bash

# Configuración de colores y símbolos
BOLD=$(tput bold)
RESET=$(tput sgr0)
GREEN=$(tput setaf 2)
BLUE=$(tput setaf 4)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
CHECK="✓"
CROSS="✗"
ARROW="➜"

# Configuración de seguridad
set -euo pipefail
trap 'echo "${RED}Error en línea $LINENO. Comando: $BASH_COMMAND${RESET}"' ERR

# Variables globales
DOTFILES_REPO="https://github.com/Shidohs/dotfile-bspwm-glass.git"
DOTFILES_DIR="$HOME/repos/dotfile-bspwm-glass"
SDDM_THEME="sugar-candy"

# Funciones de utilidad
print_header() {
    echo -e "\n${BOLD}${BLUE}==> ${1}${RESET}"
}

print_success() {
    echo -e "${GREEN}${CHECK} ${1}${RESET}"
}

print_error() {
    echo -e "${RED}${CROSS} Error: ${1}${RESET}"
}

print_info() {
    echo -e "${BOLD}${ARROW} ${YELLOW}${1}${RESET}"
}

# Funciones principales
system_update() {
    print_header "ACTUALIZANDO SISTEMA"
    sudo pacman -Syu --noconfirm
    print_success "Sistema actualizado"
}

install_yay() {
    print_header "INSTALANDO YAY"
    if ! command -v yay &>/dev/null; then
        print_info "Instalando dependencias..."
        sudo pacman -S --noconfirm base-devel git

        print_info "Clonando repositorio..."
        sudo mkdir -p /opt/yay
        sudo chown -R "$USER:" /opt/yay
        git clone https://aur.archlinux.org/yay.git /opt/yay

        print_info "Compilando e instalando..."
        (cd /opt/yay && makepkg -si --noconfirm)
        print_success "Yay instalado"
    else
        print_success "Yay ya está instalado"
    fi
}

install_packages() {
    local -A packages=(
        ["terminal"]="alacritty kitty"
        ["code"]="vscode sublime-text-4 neovim geany"
        ["file"]="thunar"
        ["web"]="firefox google-chrome"
        ["game"]="wine wine-mono winetricks"
        ["multimedia"]="viewnior celluloid ristretto"
        ["utils"]="udiskie feh rofi picom-git zsh font-manager plocate bat betterlockscreen blueman brightnessctl btop neofetch xclip curl python dunst ffmpeg fzf glow gparted grub-customizer gtk{2,3,4} imagemagick ocs-url rsync"
        ["system"]="exa jgmenu dmenu bspwm-git acpi acpid lxappearance polybar-git xautolock sddm sxhkd-git tree"
        ["fonts"]="candy-icons-git fontdownloader ttf-firacode,ttf-firacode-nerd ttf-font-awesome ttf-jetbrains-mono-nerd ttf-nerd-fonts-symbols ttf-victor-mono-nerd ttf-material-design-iconic-font ttf-material-design-icons-desktop-git"
    )

    print_header "INSTALANDO PAQUETES"

    for category in "${!packages[@]}"; do
        print_info "Instalando paquetes de ${category}..."
        yay -S --needed --noconfirm ${packages[$category]}
    done

    print_success "Todos los paquetes instalados"
}

setup_dotfiles() {
    print_header "CONFIGURANDO DOTFILES"

    if [[ ! -d "$DOTFILES_DIR" ]]; then
        print_info "Clonando repositorio..."
        mkdir -p "$(dirname "$DOTFILES_DIR")"
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    else
        print_success "Repositorio ya clonado"
    fi
}

configure_zsh() {
    print_header "CONFIGURANDO ZSH"

    # Cambiar shell por defecto
    if [[ "$SHELL" != */zsh ]]; then
        print_info "Cambiando shell a ZSH"
        chsh -s /bin/zsh
    fi

    # Instalar Oh My Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_info "Instalando Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Configuraciones adicionales
    print_info "Aplicando configuraciones..."
    ln -sfv "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
    ln -sfv "$DOTFILES_DIR/home/.p10k.zsh" "$HOME/.p10k.zsh"

    # Plugins
    local plugins=(
        "https://github.com/Aloxaf/fzf-tab"
        "https://github.com/zsh-users/zsh-syntax-highlighting"
        "https://github.com/zsh-users/zsh-autosuggestions"
    )

    for plugin in "${plugins[@]}"; do
        local plugin_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$(basename "$plugin")"
        [[ -d "$plugin_dir" ]] || git clone --depth=1 "$plugin" "$plugin_dir"
    done

    print_success "Configuración ZSH completada"
}

configure_sddm() {
    print_header "CONFIGURANDO SDDM"

    # Instalar dependencias
    sudo pacman -S --noconfirm qt5-graphicaleffects qt5-svg qt5-quickcontrols2

    # Habilitar servicio
    sudo systemctl enable sddm.service

    # Aplicar tema
    local theme_src="$DOTFILES_DIR/sddm-theme/themes/$SDDM_THEME"
    local theme_dest="/usr/share/sddm/themes/"

    if [[ -d "$theme_src" ]]; then
        print_info "Instalando tema $SDDM_THEME..."
        sudo mkdir -p "$theme_dest"
        sudo cp -vr "$theme_src" "$theme_dest"

        # Configurar tema
        sudo tee /etc/sddm.conf >/dev/null <<EOF
[Theme]
Current=$SDDM_THEME
EOF
        print_success "Tema SDDM instalado"
    else
        print_error "No se encontró el tema $SDDM_THEME"
    fi
}

setup_additional_config() {
    print_header "APLICANDO CONFIGURACIONES ADICIONALES"

    # Configuraciones de usuario
    rsync -av "$DOTFILES_DIR/home/" "$HOME/"

    # Configuraciones de root
    sudo rsync -av "$DOTFILES_DIR/home/" "/root/"

    # Configuraciones del sistema
    rsync -av "$DOTFILES_DIR/config/" "$HOME/.config/"

    # Fuentes y wallpapers
    cp -vr "$DOTFILES_DIR/Wallpaper" "$HOME/"
    fc-cache -fv

    print_success "Configuraciones aplicadas"
}

enable_services() {
    print_header "HABILITANDO SERVICIOS"
    sudo systemctl enable --now bluetooth
    print_success "Servicios habilitados"
}

main() {
    system_update
    install_yay
    install_packages
    setup_dotfiles
    configure_zsh
    configure_sddm
    setup_additional_config
    enable_services

    echo -e "\n${BOLD}${GREEN}INSTALACIÓN COMPLETADA!${RESET}"
    print_info "Reinicia el sistema para aplicar los cambios"
}

main "$@"
