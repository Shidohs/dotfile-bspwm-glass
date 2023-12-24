
# hola, apartir de aqui hare una guia completa de como instalar mi config por completo

# Validar ejecución como root 


echo "ACTUALIZANDO SISTEMA"
echo 'Verificando si tienes el sistema actualizado'
# Descomenta la siguiente línea si deseas actualizar el sistema
#sudo pacman -Syu

echo "----- INSTALANDO YAY -----"
#configurando yay y personalizando la terminal

if  pacman -Qq "yay" &> /dev/null ; then
    echo "yay: instalado"
else
    sudo pacman -S base-devel zsh git
    cd /opt
    git clone https://aur.archlinux.org/yay.git /opt/yay
    chown -R $USER: /opt/yay 
    cd /opt/yay
    makepkg -si
    clear

fi

echo 'Comprobando si existen los programas requeridos para el funcionamiento'

# Lista de programas por categoría
terminal=("alacritty" "kitty")
code=("code" "sublime-text-4" "neovim" "geany")  
file=("thunar")
accesorios=()
web=("firefox")
game=("wine" "wine-mono" "winetricks")
multimedia=("viewnior" "celluloid" "ristretto")
otros=("picom-ftlabs-git" "zsh" "font-manager" "plocate" "bat" "pamac-manager" "betterlockscreen"  
"blueman" "brightnessctl" "btop" "neofetch" "xclip" "curl" "python"  
"dunst" "ffmpeg" "fzf" "glow" "gparted" "grub-customizer" "gtk" "gtk2" "gtk3"  
"gtk4" "imagemagick" "ocs-url")
sistema=("bspwm" "xfce" "acpi" "lxappearance" "polybar" "xautolock")
fonts=("ttf-fira-code" "ttf-firacode-nerd" "ttf-font-awesome" "ttf-jetbrains-mono-nerd" "ttf-nerd-fonts-symbols" "ttf-victor-mono-nerd")
rofitheme=("sddm" "sxhkd" "tree")


# Función para instalar 
check_and_install() {
  if ! pacman -Qq "$@" &> /dev/null && ! yay -Qq "$@" &> /dev/null; then
    
    echo "Instalando $@"
    if ! sudo pacman -S "$@"; then
      echo "Error instalando $@" >&2
    fi
    
  fi
}

# Comprobar programas e instalar si no existen
for programa in "${terminal[@]}" "${code[@]}" "${file[@]}" "${accesorios[@]}" "${web[@]}" "${game[@]}" "${multimedia[@]}" "${otros[@]}" "${sistema[@]}" "${fonts[@]}" "${rofitheme[@]}"; do
  check_and_install "$programa"
done

# Verificar al final
faltantes=()

for programa in "${faltantes[@]}"; do
  if ! pacman -Qq "$programa" &> /dev/null; then
    faltantes+=("$programa") 
  fi
done

# Reintentar faltantes
if [ ${#faltantes[@]} -gt 0 ]; then
  
  echo "No se pudieron instalar: ${faltantes[@]}"
  
  for programa in "${faltantes[@]}"; do
    check_and_install "$programa"
  done
  
fi

# Mensaje resultado
echo "Programas Instalandos Correctamente"







