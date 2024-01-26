#!/bin/bash

cd 
# hola, apartir de aqui hare una guia completa de como instalar mi config por completo
echo "ACTUALIZANDO SISTEMA"
echo 'Verificando si tienes el sistema actualizado'
# Descomenta la siguiente línea si deseas actualizar el sistema
sudo pacman -Syu

echo "----- INSTALANDO YAY -----"
#configurando yay y personalizando la terminal

if  pacman -Qq "yay" &> /dev/null ; then
    echo "yay: instalado"
else
    sudo pacman -S --noconfirm base-devel zsh git
    cd /opt
    git clone https://aur.archlinux.org/yay.git /opt/yay
    chown -R $USER: /opt/yay 
    cd /opt/yay
    makepkg -si

fi

echo "----- INSTALANDO PROGRAMAS REQUERIDOS -----"
echo 'Comprobando si existen los programas requeridos para el funcionamiento'

# Lista de programas por categoría
terminal=("alacritty" "kitty")
code=("vscodium" "sublime-text-4" "neovim" "geany")  
file=("thunar" "nemo")
web=("firefox" "google-chrome")
game=("wine" "wine-mono" "winetricks")
multimedia=("viewnior" "celluloid" "ristretto")
otros=("picom-ftlabs-git" "zsh" "font-manager" "plocate" "bat" "betterlockscreen"  
"blueman" "brightnessctl" "btop" "neofetch" "xclip" "curl" "python"  
"dunst" "ffmpeg" "fzf" "glow" "gparted" "grub-customizer" "gtk" "gtk2" "gtk3"  
"gtk4" "imagemagick" "ocs-url")
sistema=("bspwm" "acpi" "acpid" "lxappearance" "polybar" "xautolock" "sddm" "sxhkd" "tree")
fonts=("fontdownloader" "ttf-fira-code" "ttf-firacode-nerd" "ttf-font-awesome" "ttf-jetbrains-mono-nerd" "ttf-nerd-fonts-symbols" "ttf-victor-mono-nerd" "ttf-material-design-iconic-font" "ttf-material-design-icons-desktop-git" "")



# Función para instalar 
check_and_install() {
  if ! pacman -Qq "$1" >/dev/null; then
    if pacman -S --noconfirm "$1" >/dev/null; then
      echo "Instalado $1 con pacman"
    else
      echo "No se pudo instalar $1 con pacman, intentando con yay" 
      yay -S --noconfirm "$1" >/dev/null || echo "Error instalando $1"
    fi
  fi
}

# Comprobar programas e instalar si no existen
for programa in "${terminal[@]}" "${code[@]}" "${file[@]}" "${accesorios[@]}" "${web[@]}" "${game[@]}" "${multimedia[@]}" "${otros[@]}" "${sistema[@]}"; do
  check_and_install "$programa"
done
# Mensaje resultado
echo "Programas Instalados Correctamente"

# creando directorio de repos
if test -d "~/repos" ; then
    echo "carpeta: 'repos', ya existe"
    cd ~/repos
else
    mkdir -p ~/repos
    cd ~/repos
    echo "carpeta:'repos' creada"
fi

#clonar repo

echo "----- CLONANDO REPO -----"
dotfile_directory="$HOME/repos/dotfile-i3-bspwm"

if [ -d "$dotfile_directory" ] ; then
    if [ "$(ls -A $dotfile_directory)" ]; then
        echo "El directorio $dotfile_directory ya existe y no está vacío. No se realizará la clonación."
    else
        echo "El dotfile-i3-bspwm ya está instalado en $dotfile_directory."
    fi
else
    echo "No está instalado el dotfile, se comenzará a clonar."
    git clone https://github.com/Shidohs/dotfile-i3-bspwm.git "$dotfile_directory"
fi

echo "----- MODIFICANDO TERMINAL -----"
# copiar config de zshrc
if test -e "~/.zshrc"; then
    cd ~/repos/dotfile-i3-bspwm 
    cp -r home/.zshrc ~/

else

    echo "archivo existe,comenzare a respaldar:zshrc"
    cp ~/.zshrc ~/.zshrc.bak
    echo "zshrc modificado"
    cp -r ~/repos/dotfile-i3-bspwm/home/.zshrc ~/

fi 
cd dotfile-i3-bspwm

#instalar y configurar ohmyzsh
if test -d "~/.oh-my-zsh"; then
  echo "no instalado, comenzara a instalarse"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

else
  echo "el ohmyzsh ya esta instalado"
fi


#instalar y copiar config de powerlevel10k 
if test -d "~/.oh-my-zsh/custom/themes/powerlevel10k" ; then
    echo "powerlevel10k no esta instalado,comenzara a instalarse"
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k 
    cp ~/repos/dotfile-i3-bspwm/home/.p10k.zsh ~/
else
    echo "powerlevel10k esta instalado"
    echo "modificando .p10k.zsh"
    cp ~/repos/dotfile-i3-bspwm/home/.p10k.zsh ~/
fi

# hacer este proceso en root

# Instalar oh-my-zsh como root
if [ ! -d "/root/.oh-my-zsh" ]; then

  echo "Instalando oh-my-zsh para root..."
  
  sudo -u root sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  
else
  
  echo "oh-my-zsh ya está instalado para root"
  
fi

# Instalar powerlevel10k para root
if [ ! -d "/root/.oh-my-zsh/custom/themes/powerlevel10k" ]; then

  echo "Instalando powerlevel10k para root..."
  
  sudo -u root git clone --depth=1 https://github.com/romkatv/powerlevel10k.git /root/.oh-my-zsh/custom/themes/powerlevel10k
  
  sudo cp ~/repos/dotfile-i3-bspwm/root/.p10k.zsh /root/
  
else
  
  echo "powerlevel10k ya está instalado para root"
  
  sudo cp ~/repos/dotfile-i3-bspwm/root/.p10k.zsh /root/
  
fi

#Plugins
echo "----- INSTALANDO PLUGINS -----"
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

#depedencia
echo "dependencias para el tema"
if yay -Qt "qt5-graphicaleffects" &> /dev/null && \
    yay -Qt "qt5-svg" &> /dev/null && \
    yay -Qt "qt5-quickcontrols2" &> /dev/null;then
        echo "Dependecias para sddm-theme: Instalados"
else
    sudo pacman -S --noconfirm qt5-graphicaleffects qt5-svg qt5-quickcontrols2 
    echo "Dependecias para sddm-theme: Instalados"
fi


if pacman -Qq "sddm"; then

  echo "sddm: ya esta instalado"
  
  if [ -d "/usr/share/sddm/themes" ]; then
  
    echo "Cargando tema"  
    sudo cp -r ~/repos/dotfile-i3-bspwm/sddm-theme/themes/ /usr/share/sddm/themes/
    
    if [[ ! -f /etc/sddm.conf ]]; then
    
      sudo tee /etc/sddm.conf <<EOF

[Theme]
Current=corners
EOF
    
    fi
  
  fi

else

  echo "Instalando SDDM"
  sudo pacman -S  --noconfirm sddm
  
  if [ -d "/usr/share/sddm/themes" ]; then
  
    echo "Cargando tema"
    sudo cp -r ~/repos/dotfile-i3-bspwm/sddm-theme/themes/ /usr/share/sddm/themes/
    
    if [[ ! -f /etc/sddm.conf ]]; then
    
      sudo tee /etc/sddm.conf <<EOF  
[Theme]
Current=corners
EOF
    
    fi
    
  fi

fi

# instalando el repo chaotic
echo "----- INSTALANDO REPO CHAOTIC_EUR -----"

# Instalar clave primaria
sudo pacman -Sc --noconfirm
sudo pacman-key --init
sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB

# Instalar keyring y mirrorlist
if ! pacman -Qq chaotic-keyring &> /dev/null; then
  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
  sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
  sudo pacman -Sc --noconfirm
fi

# Configurar pacman.conf
if ! grep -q "\[chaotic-aur\]" /etc/pacman.conf; then

  # Agregar sección [chaotic-aur]
  echo '[chaotic-aur]' | sudo tee -a /etc/pacman.conf

  # Agregar directiva Include
  echo 'Include = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf

fi

echo "----- INSTALANDO TIENDA DE ARCH -----"
#isntalando la tienda de arch

if pacman -Qq "pamac-all";then
    echo "Tienda Aur: Instalado"
    if pacman -Qq "powerpill"; then
      sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
    else
      sudo pacman -S powerpill
      sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su
    fi
    
     
else
    echo "Tienda Aur: No Instalado"
    yay -S pamac-all
    sudo pacman -S powerpill
    sudo pacman -Sy --noconfirm && sudo powerpill -Su && yay -Su 
fi

#instalando las fuentes
echo "----- INSTALANDO FUENTES -----"
for font in "${terminal[@]}"; do
   check_and_install "$font"
done

cd ~/repos
cp -r dotfile-i3-bspwm/home/.fonts/ ~/

# configurando el thema general de ldesktop

echo "----- CONFIGURANDO EL TEMA DE BSPWM -----"

cd dotfile-i3-bspwm/
cp -r home/ ~/

# wallpaper
echo "----- MOVIENDO WALL -----"
cp -r Wallpaper/ ~/

#Config de .config
echo "COPIANDO TODO .CONFIG"
cp -r config/ ~/.config


echo "INSTALACION COMPLETADA"


