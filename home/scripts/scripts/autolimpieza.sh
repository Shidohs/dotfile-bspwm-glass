#!/bin/bash
# actualizar repositorios
sudo pacman -Syu
# Eliminar paquetes huerfanos
sudo pacman -Rns $(pacman -Qdtq)
# limpiar cache de paquetes
sudo pacman -Sc
# Eliminar paquetes  en desuso 
sudo pacman -Rns $(pacman -Qqdt)
# limpiar registros antiguos
sudo journalctl --vacuum-size=50M
# Eliminar archivos temporales
sudo rm -r /tmp/*

echo "!!Limpieza Completada!!"
