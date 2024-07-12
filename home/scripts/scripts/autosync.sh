#! /bin/bash
# version 1.2

echo "Sincronizar datos para el dotfile : bspwm"
home=(
  .p10k.zsh
  .aliases
  .gtkrc-2.0
  .xprofile
  .xautolock
  .zshrc
  .Xauthority
  .Xresources
)

home_dest="$HOME/repos/dotfile-bspwm-glass/home/"

for item in "${home[@]}"; do
  if [[ -d "$HOME/$item" ]]; then # Verificar si es un directorio
    rsync -avr "$HOME/$item/" "$home_dest$item/"
  else
    rsync -av "$HOME/$item" "$home_dest"
  fi
done
#HOME
rsync -av --delete ~/.fonts ~/repos/dotfile-bspwm-glass/home/.fonts/
rsync -av --delete ~/.icons/ ~/repos/dotfile-bspwm-glass/home/.icons/
rsync -av --delete ~/.themes/ ~/repos/dotfile-bspwm-glass/home/.themes/
rsync -av --delete ~/.themes/Sweet-Dark-v40/ ~/repos/dotfile-bspwm-glass/home/.themes/Sweet-Dark-v40/
rsync -av --delete ~/.local/share/fonts/ ~/repos/dotfile-bspwm-glass/home/.local/share/fonts/
rsync -av --delete ~/.local/share/sddm/ ~/repos/dotfile-bspwm-glass/home/.local/share/sddm/
rsync -av --delete ~/.local/share/rofi/themes/ ~/repos/dotfile-bspwm-glass/home/.local/share/rofi/themes/
rsync -avr ~/.gtkrc-2.0 ~/repos/dotfile-bspwm-glass/home/
rsync -av --delete ~/Wallpapers/ ~/repos/dotfile-bspwm-glass/Wallpapers/
#CONFIG
rsync -av --delete ~/.config/sakura/ ~/repos/dotfile-bspwm-glass/config/sakura/
rsync -avr ~/scripts/install_config.sh ~/repos/dotfile-bspwm-glass/install_config.sh
rsync -av --delete ~/.config/alacritty/ ~/repos/dotfile-bspwm-glass/config/alacritty/
rsync -av --delete ~/.config/btop/ ~/repos/dotfile-bspwm-glass/config/btop/
rsync -av --delete ~/.config/bspwm/ ~/repos/dotfile-bspwm-glass/config/bspwm/
rsync -av --delete ~/.config/dunst/ ~/repos/dotfile-bspwm-glass/config/dunst/
rsync -av --delete ~/.config/gtk-3.0/ ~/repos/dotfile-bspwm-glass/config/gtk-3.0/
rsync -av --delete ~/.config/htop/ ~/repos/dotfile-bspwm-glass/config/htop/
rsync -av --delete ~/.config/neofetch/ ~/repos/dotfile-bspwm-glass/config/neofetch/
rsync -av --delete ~/.config/rofi/ ~/repos/dotfile-bspwm-glass/config/rofi/
rsync -av --delete ~/.config/gtk-2.0/ ~/repos/dotfile-bspwm-glass/config/gtk-2.0/
rsync -av --delete ~/.config/gtk-4.0/ ~/repos/dotfile-bspwm-glass/config/gtk-4.0/
rsync -av --delete ~/.config/kitty/ ~/repos/dotfile-bspwm-glass/config/kitty/
rsync -av --delete ~/.config/picom/ ~/repos/dotfile-bspwm-glass/config/picom/
rsync -avr ~/.config/mimeapps.list ~/repos/dotfile-bspwm-glass/config/mimeapps.list
rsync -av --delete ~/.config/xsettingsd/ ~/repos/dotfile-bspwm-glass/config/xsettingsd/
