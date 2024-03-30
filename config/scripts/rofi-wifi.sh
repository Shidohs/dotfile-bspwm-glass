#!/usr/bin/env bash

notify-send "Lista de redes Wi-Fi disponibles..."
# Obtener una lista de conexiones wifi disponibles y transformarla en una lista agradable
wifi_list=$(nmcli --fields "IN-USE,SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d" | sed 's/^*/ /g' | sed 's/^\*/ * /')

connected=$(nmcli -fields WIFI g)
if [[ "$connected" =~ "enabled" ]]; then
	toggle="睊  Disable Wi-Fi"
elif [[ "$connected" =~ "disabled" ]]; then
	toggle="直  Enable Wi-Fi"
fi

# Usar rofi para seleccionar la red wifi
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -theme ~/.config/bspwm/rofi/themes/rounded-gray-dark.rasi -dmenu -i -selected-row 1 -p "SSID Wi-Fi: " )
# Obtener el nombre de la conexión
chosen_id=$(echo "${chosen_network:3}" | xargs)

if [ -z "$chosen_network" ]; then
	exit
elif [ "$chosen_network" = "直  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "睊  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Mensaje para mostrar cuando la conexión se activa con éxito
	success_message="Ahora estás conectado a la red Wi-Fi \"$chosen_id\"."
	# Obtener conexiones guardadas
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		nmcli connection up id "$chosen_id" --ask | grep "successfully" && notify-send "Conexión Establecida" "$success_message"
	else
		conexion_exitosa=false
		while [ $conexion_exitosa == false ]; do
			if [[ "$chosen_network" =~ "" ]]; then
				wifi_password=$(rofi -dmenu -p "Password: " )
			fi
			conexion_resultado=$(nmcli device wifi connect "$chosen_id" password "$wifi_password" 2>&1)
			if [[ "$conexion_resultado" =~ "successfully" ]]; then
				notify-send "Conexión Establecida" "$success_message"
				conexion_exitosa=true
			else
				notify-send "Error de Conexión" "Contraseña incorrecta. Por favor, inténtalo de nuevo."
			fi
		done
	fi
fi
