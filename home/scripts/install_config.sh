#!/bin/bash

# hola, apartir de aqui hare una guia completa de como instalar mi config por completo
echo "ACTUALIZANDO SISTEMA"
echo 'Verificando si tienes el sistema actualizado'
sudo pacman -Syu

echo "----- INSTALANDO YAY -----"
#configurando yay y personalizando la terminal

# Comprueba si yay está instalado
if pacman -Qq "yay" &>/dev/null; then
  echo "yay está instalado."
else
  echo "yay no está instalado. Instalando..."

  # Instala los paquetes requeridos
  sudo pacman -S --noconfirm base-devel zsh git

  # Clona el repositorio AUR de yay
  git clone https://aur.archlinux.org/yay.git /opt/yay
  sudo chown -R "$USER": /opt/yay

  # Compila e instala yay
  cd /opt/yay || exit
  makepkg -si
  echo "yay instalado correctamente."
fi

echo "----- INSTALANDO PROGRAMAS REQUERIDOS -----"
echo 'Comprobando si existen los programas requeridos para el funcionamiento'

# Lista de programas por categoría
terminal=("alacritty" "kitty")
code=("vscode" "sublime-text-4" "neovim" "geany")
file=("thunar")
web=("firefox" "google-chrome")
game=("wine" "wine-mono" "winetricks")
multimedia=("viewnior" "celluloid" "ristretto")
otros=("picom-ftlabs-git" "zsh"
  "font-manager" "plocate" "bat" "betterlockscreen"
  "blueman" "brightnessctl" "btop" "neofetch" "xclip" "curl" "python"
  "dunst" "ffmpeg" "fzf" "glow" "gparted" "grub-customizer" "gtk" "gtk2" "gtk3"
  "gtk4" "imagemagick" "ocs-url" "rsync")
sistema=("sakura" "exa" "jgmenu" "dmenu" "bspwm" "acpi" "acpid" "lxappearance" "polybar" "xautolock" "sddm" "sxhkd" "tree" "gvfs-mtp")
fonts=("candy-icons-git" "fontdownloader" "ttf-firacode" "ttf-firacode-nerd" "ttf-font-awesome" "ttf-jetbrains-mono-nerd" "ttf-nerd-fonts-symbols" "ttf-victor-mono-nerd" "ttf-material-design-iconic-font" "ttf-material-design-icons-desktop-git" "")

# Función para instalar

echo "INSTALANDO PROGRAMAS NECESARIOS"
check_and_install() {
  if ! pacman -Qq "$1" >/dev/null; then
    if sudo pacman -S --noconfirm "$1" >/dev/null; then
      echo "Instalado $1 con pacman"
    else
      echo "No se pudo instalar $1 con pacman, intentando con yay"
      yay -S --noconfirm "$1" >/dev/null || echo "Error instalando $1"
    fi
  fi
}
# Comprobar programas e instalar si no existen
for programa in "${terminal[@]}" "${code[@]}" "${file[@]}" "${web[@]}" "${game[@]}" "${multimedia[@]}" "${otros[@]}" "${sistema[@]}" "${fonts[@]}"; do
  check_and_install "$programa"
done
# Mensaje resultado
echo "Programas Instalados Correctamente"

# creando directorio de repos
# Verifica si la carpeta "repos" existe
if [ ! -d "$HOME/repos" ]; then
  # Si no existe, la crea
  echo "Carpeta 'repos' no existe. Creando..."
  mkdir -p "$HOME/repos"
  cd "$HOME/repos" || exit
  echo "Carpeta 'repos' creada correctamente."
else
  # Si existe, navega a ella
  cd "$HOME/repos" || exit
  echo "Carpeta 'repos' encontrada. Navegando a ella..."
fi

#clonar repo

echo "----- CLONANDO REPO -----"
dotfile_directory="$HOME/repos/dotfile-bspwm-glass"

if [ -d "$dotfile_directory" ]; then
  if [ "$(ls -A "$dotfile_directory")" ]; then
    echo "El directorio $dotfile_directory ya existe y no está vacío. No se realizará la clonación."
  else
    echo "El dotfile-bspwm-glass ya está instalado en $dotfile_directory."
  fi
else
  echo "No está instalado el dotfile, se comenzará a clonar."
  git clone https://github.com/Shidohs/dotfile-bspwm-glass.git "$dotfile_directory"
fi

echo "----- CAMBIANDO LA SHELL -----"

chsh -s /bin/zsh

echo "----- MODIFICANDO TERMINAL -----"
# copiar config de zshrc
echo "Moviendo archivo .zshrc"
ZSHRC_FILE="$HOME/.zshrc"
ZSHRC_BACKUP="$HOME/.zshrc.bak"
ZSHRC_DEST="$HOME/repos/dotfile-bspwm-glass/home/.zshrc"
# Comprueba si el archivo .zshrc existe
if [ -e "$ZSHRC_FILE" ]; then
  echo "El archivo .zshrc existe, creando un respaldo..."
  cp "$ZSHRC_FILE" "$ZSHRC_BACKUP"
  echo "El archivo .zshrc ha sido respaldado en $ZSHRC_BACKUP."
  echo "----------------------------------------------"
  cp -r "$ZSHRC_DEST" "$ZSHRC_FILE" || exit
  echo "El archivo .zshrc ha sido modificado."
else
  echo "El archivo .zshrc no existe, actualizando..."
  cp -r "$ZSHRC_DEST" "$ZSHRC_FILE"
  echo "El archivo .zshrc ha sido modificado."
fi

echo "----- INSTALAND OHMYZSH -----"
cd dotfile-bspwm-glass || exit
#instalar y configurar ohmyzsh
if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
  echo "No está instalado Oh My Zsh, comenzará la instalación"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh ya está instalado"
fi

echo "creando enlace para root de'Oh My Zsh'"
# Instalar oh-my-zsh como root
sudo ln -s "$HOME"/.oh-my-zsh /root/
echo "Enlazado"

# tema pówerlevel10k
echo "INSTALANDO TEMA POWERLEVEL10K"
if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo "powerlevel10k no está instalado, comenzará a instalarse"
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  echo "Modificando .p10k.zsh"
  cp ~/repos/dotfile-bspwm-glass/home/.p10k.zsh ~/
else
  echo "powerlevel10k está instalado"
  echo "Modificando .p10k.zsh"
  cp ~/repos/dotfile-bspwm-glass/home/.p10k.zsh ~/
fi

echo "---------------------"
echo "----- HACER ESTE PROCESO EN ROOT -----"

echo "creando enlace para root de'aliases y .zshrc'"
# ROOT
sudo ln -s ~/.zshrc /root/
sudo ln -s ~/.aliases /root/

#Plugins
echo "----- INSTALANDO PLUGINS EN USER -----"
echo "Instalando plugins de ohmyzsh"
# Verificar si los repositorios fzf-tab, zsh-syntax-highlighting y zsh-autosuggestions están clonados
if [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab" ] &&
  [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ] &&
  [ -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
  echo "Los repositorios ya están clonados."
else
  # Clonar los repositorios fzf-tab, zsh-syntax-highlighting y zsh-autosuggestions
  git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

# configurando sddm como gestor predeterminado

echo "----- CONFIGURANDO SDDM -----"

echo "Desactivando su DM predeterminado"
sudo systemctl disable $(systemctl list-unit-files --type=service --state=enabled | grep 'dm\.service' | awk '{print $1}')
echo "Activar SDDM como display manager (DM) predeterminado"
sudo systemctl enable sddm.service

echo "SDDM activado como DM predeterminado"

sddm_theme_dir="$HOME/repos/dotfile-bspwm-glass/sddm-theme/themes/"
new_theme="corners"
#depedencia
echo "dependencias para el tema"
if pacman -Q "qt5-graphicaleffects" &>/dev/null &&
  pacman -Q "qt5-svg" &>/dev/null &&
  pacman -Q "qt5-quickcontrols2" &>/dev/null; then
  echo "Dependencias para sddm-theme: Instalados"
else
  sudo pacman -S --noconfirm qt5-graphicaleffects qt5-svg qt5-quickcontrols2
  echo "Dependencias para sddm-theme: Instalados"
fi

if ! pacman -Qq "sddm" >/dev/null; then
  echo "sddm: no está instalado"
  echo "Instalando SDDM"
  sudo pacman -S --noconfirm sddm
fi

if [ -d "/usr/share/sddm/themes" ]; then
  echo "Cargando tema"
  if [ -d "$sddm_theme_dir" ]; then
    sddm_theme_dest="/usr/share/sddm/themes/"
    if [ ! -d "$sddm_theme_dest" ]; then
      sudo mkdir -p "$sddm_theme_dest"
    fi
    sudo rsync -av "$sddm_theme_dir" "$sddm_theme_dest"

    # Leer el archivo /etc/sddm.conf
    if grep -q '^Current=' /etc/sddm.conf; then
      # Reemplazar el valor de Current= con el nuevo tema
      sudo sed -i "s/^Current=.*/Current=$new_theme/" /etc/sddm.conf
    else
      # Si no hay una línea Current=, agregar una nueva
      sudo tee -a /etc/sddm.conf >/dev/null <<EOF
[Theme]
Current=$new_theme
EOF
    fi
  else
    echo "El directorio $sddm_theme_dir no existe"
  fi
else
  echo "El directorio /usr/share/sddm/themes no existe"
fi

echo "SDDM configurado"

# instalando el repo chaotic
echo "----- INSTALANDO REPO CHAOTIC_EUR -----"

# Instalar clave primaria
sudo pacman -Sc --noconfirm
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

# Instalar keyring y mirrorlist
if ! pacman -Qq chaotic-keyring &>/dev/null; then
  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  sudo pacman -Sc --noconfirm
fi

# Configurar pacman.conf

if [ -f "/etc/pacman.d/chaotic-mirrorlist" ]; then
  if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then

    # Agregar sección [chaotic-aur]
    echo '[chaotic-aur]' | sudo tee -a /etc/pacman.conf

    # Agregar directiva Include
    echo 'Include = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf

  fi
else
  echo "El archivo /etc/pacman.d/chaotic-mirrorlist no existe."
fi

echo "----- INSTALANDO TIENDA DE ARCH -----"
#isntalando la tienda de arch

if pacman -Qq "pamac-all"; then
  echo "Tienda Aur: Instalado"
  if pacman -Qq "powerpill"; then
    sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
  else
    yay -S --noconfirm powerpill
    sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
  fi

else
  echo "Tienda Aur: No Instalado"
  yay -S --noconfirm pamac-all
  yay -S --noconfirm powerpill
  sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
fi

#instalando las fuentes
echo "----- INSTALANDO FUENTES -----"
for font in "${terminal[@]}"; do
  check_and_install "$font"
done
rsync -av ~/repos/dotfile-bspwm-glass/home/.fonts/ ~/.fonts/

# configurando el tema general de ldesktop

echo "----- CONFIGURANDO EL TEMA DE BSPWM -----"

rsync -av ~/repos/dotfile-bspwm-glass/home/ ~/
rsync -av ~/repos/dotfile-bspwm-glass/home/ /root/

# wallpaper
echo "----- MOVIENDO WALL -----"
cp -r ~/repos/dotfile-bspwm-glass/Wallpaper ~/

#Config de .config
echo "COPIANDO TODO .CONFIG"
rsync -av ~/repos/dotfile-bspwm-glass/config/ ~/.config

#Iniciando el servicio de bluetooth
sudo systemctl start bluetooth
sudo systemctl enable bluetooth

# ln para los demas archivos
#echo "CREANDO ENLACES"
xrdb -merge ~/.Xresources
echo "INSTALACION COMPLETADA"
