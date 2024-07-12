#!/bin/bash

# Este script limpia varios aspectos del sistema en Arch Linux.

# Función para mostrar mensajes
echo_msg() {
	echo -e "\033[1;32m$1\033[0m"
}

# Limpiar la caché de pacman
echo_msg "Limpiando la caché de pacman..."
sudo pacman -Scc --noconfirm

# Eliminar paquetes órfanos
echo_msg "Eliminando paquetes órfanos..."
sudo pacman -Rns $(pacman -Qdtq) --noconfirm

# Limpiar archivos temporales
echo_msg "Limpiando archivos temporales..."
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*

# Limpiar el journal de systemd
echo_msg "Limpiando el journal de systemd..."
sudo journalctl --vacuum-time=2weeks

# Limpiar caché de usuario
echo_msg "Limpiando caché del usuario..."
rm -rf ~/.cache/*

# Limpiar miniaturas
echo_msg "Limpiando miniaturas del usuario..."
rm -rf ~/.thumbnails/*

echo_msg "Limpieza completa."

exit 0
