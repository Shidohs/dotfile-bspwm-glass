#!/bin/bash

# Función para obtener la lista de redes WiFi disponibles
get_wifi_list() {
	nmcli -f SSID,SIGNAL,SECURITY dev wifi list | tail -n +2 | sed 's/  */ /g' | sort -k2 -nr
}

# Función para conectarse a una red WiFi
connect_to_wifi() {
	local ssid="$1"
	local password="$2"
	nmcli device wifi connect "$ssid" password "$password"
}

# Función para mostrar el menú principal
show_main_menu() {
	local options="1. Ver redes WiFi disponibles\n2. Conectar a una red WiFi\n3. Desconectar WiFi actual\n4. Ver estado de la conexión"
	echo -e "$options" | rofi -dmenu -p "Gestor WiFi" -i
}

# Función principal
main() {
	local choice=$(show_main_menu)

	case "$choice" in
	"1. Ver redes WiFi disponibles")
		get_wifi_list | rofi -dmenu -p "Redes WiFi disponibles" -i
		;;
	"2. Conectar a una red WiFi")
		local ssid=$(get_wifi_list | rofi -dmenu -p "Selecciona una red" -i | cut -d' ' -f1)
		if [ -n "$ssid" ]; then
			local password=$(rofi -dmenu -p "Ingresa la contraseña para $ssid" -password)
			connect_to_wifi "$ssid" "$password"
		fi
		;;
	"3. Desconectar WiFi actual")
		nmcli device disconnect wlan0
		;;
	"4. Ver estado de la conexión")
		nmcli dev status | rofi -dmenu -p "Estado de la conexión" -i
		;;
	esac
}

# Ejecutar la función principal
main
