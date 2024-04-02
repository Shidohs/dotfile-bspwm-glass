#!/usr/bin/env bash

# Version : 1.2
# Este script fue creado por [Shidohs]
# Puedes encontrarme en [www.github.com/Shidohs]




notify-send "Lista de redes Wi-Fi disponibles..."

# Obtener una lista de conexiones wifi disponibles y transformarla en una lista agradable
wifi_list=$(nmcli --fields "IN-USE,SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d" | sed 's/^*/ON /g' | sed 's/^\*/ * /')

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
    # Mostrar opciones adicionales para la red seleccionada
    if [[ "$chosen_network" =~ "ON" ]]; then
        options=(
            "   Olvidar" "Cancelar"
        )
        options_formatted=$(printf "%s\n" "${options[@]}")
        chosen_action=$(echo -e "${options_formatted}" | rofi -theme ~/.config/bspwm/rofi/themes/rounded-gray-dark.rasi -dmenu -i -p "¿Qué acción deseas realizar?")

        case "$chosen_action" in
            "   Olvidar")
                nmcli connection delete "$chosen_id"
                notify-send "Red olvidada" "La red Wi-Fi \"$chosen_id\" ha sido olvidada."
                exit
                ;;
            "Cancelar")
                notify-send "Cancelado." 
                exit
                ;;
        esac
fi
fi



    # Mensaje para mostrar cuando la conexión se activa con éxito
    success_message="Ahora estás conectado a la red Wi-Fi: \"$chosen_id\"."
    # Obtener conexiones guardadas
    saved_connections=$(nmcli -g NAME connection)
    if [[ $(echo "$saved_connections" | grep -w "$chosen_id") = "$chosen_id" ]]; then
        nmcli connection up id "$chosen_id" --ask | grep "successfully" && notify-send "Conexión Establecida" "$success_message"
    else
        connection_successful=false
        attempts=0
        while [ $connection_successful == false ]; do
            if [[ "$chosen_network" =~ "" ]]; then
                wifi_password=$(rofi -theme ~/.config/bspwm/rofi/themes/rounded-gray-dark.rasi -dmenu -p "Password: " )

                # Verificar si el usuario canceló la selección de contraseña
                if [ -z "$wifi_password" ]; then
                    notify-send "Operación Cancelada" "La selección de contraseña ha sido cancelada."
                    exit
                fi
            fi
            connection_result=$(nmcli device wifi connect "$chosen_id" password "$wifi_password" 2>&1)
            if [[ "$connection_result" =~ "successfully" ]]; then
                notify-send "Conexión Establecida" "$success_message"
                connection_successful=true
            else
                notify-send "Error de Conexión" "Contraseña incorrecta. Por favor, inténtalo de nuevo."
                ((attempts++))
                # Limitar el número de intentos
                if [ $attempts -ge 3 ]; then
                    notify-send "Número máximo de intentos alcanzado" "Se ha alcanzado el número máximo de intentos para ingresar la contraseña."
                    exit
                fi
            fi
        done
    fi


