#!/bin/bash

# Verificar si el comando 'ip' está disponible
if ! command -v ip &>/dev/null; then
    echo "Error: El comando 'ip' no está instalado."
    exit 1
fi

# Buscar la interfaz Ethernet activa
eth_interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^e' | head -n 1)

# Buscar la interfaz Wi-Fi activa
wifi_interface=$(ip -o link show | awk -F': ' '{print $2}' | grep -E '^w' | head -n 1)

# Función para verificar si una interfaz está activa
is_interface_up() {
    ip link show "$1" | grep -q "state UP"
}

# Función para verificar conexión a Internet
check_internet() {
    ping -c 1 -W 1 google.com >/dev/null 2>&1
    return $?
}

# Determinar qué tipo de conexión está activa
if [ -n "$eth_interface" ] && is_interface_up "$eth_interface" && check_internet; then
    icon=""             # Ícono de Ethernet conectado
    foreground="#A3BE8C" # Verde para Ethernet
elif [ -n "$wifi_interface" ] && is_interface_up "$wifi_interface" && check_internet; then
    icon=""             # Ícono de Wi-Fi conectado
    foreground="#A3BE8C" # Verde para Wi-Fi
else
    icon="󰖪"             # Ícono de desconexión
    foreground="#D35F5E" # Rojo para desconexión
fi

# Salida para Polybar
echo "%{F$foreground}$icon%{F-}"
