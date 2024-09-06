#!/bin/bash

# Limpiar el caché de pacman
sudo pacman -Scc

# Limpiar los archivos temporales
sudo rm -rf /tmp/*

# Limpiar los archivos de sesión viejos
sudo find /var/lib/systemd/coredump -type f -atime +7 -delete

# Limpiar los archivos de registro viejos
sudo journalctl --vacuum-size=100M

# Limpiar los archivos de registro rotados
sudo find /var/log -type f -name "*.log.old" -delete

# Limpiar los archivos de registro rotados comprimidos
sudo find /var/log -type f -name "*.gz" -delete

# Limpiar los archivos basura de Firefox
rm -rf ~/.cache/mozilla/firefox/*

# Limpiar los archivos basura de Chrome
rm -rf ~/.cache/google-chrome/*

# Limpiar los archivos basura de Thunderbird
rm -rf ~/.cache/thunderbird/*

# Limpiar los archivos basura de otros programas
rm -rf ~/.cache/*

# Limpiar los archivos basura del sistema
sudo rm -rf /var/cache/*

# Notificar al usuario que la limpieza ha finalizado
echo "La limpieza ha finalizado correctamente."

