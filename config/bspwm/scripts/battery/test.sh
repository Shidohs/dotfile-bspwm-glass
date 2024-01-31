#!/bin/bash

# Directorio de iconos
icon_dir="$HOME/.config/bspwm/assets/battery"

# Función para notificar  
notify() {
  dunstify -i "$icon_dir/${1}" "${2}" "${3}"
}

# Flags para notificar una vez
notified_full=false
notified_low=false
notified_critical=false
notified_charging=false
notified_disconnected=false

# Función para reiniciar flags
reset_flags() {
  notified_full=false
  notified_low=false
  notified_critical=false
  notified_charging=false
  notified_disconnected=false
}

# Monitorear cambios en el estado de la batería
while true; do
  inotifywait -q -e modify --format "%w%f" /sys/class/power_supply/BAT*/status /sys/class/power_supply/BAT*/capacity |
  while read -r changed_file; do
    case $changed_file in
      *status )
        if [ -e "/sys/class/power_supply/BAT*/status" ]; then
          battery_status=$(cat /sys/class/power_supply/BAT*/status)
        else
          echo "Error: No se puede leer el archivo de estado de la batería."
          continue
        fi
        ;;

      *capacity )
        if [ -e "/sys/class/power_supply/BAT*/capacity" ]; then
          battery_capacity=$(cat /sys/class/power_supply/BAT*/capacity)
        else
          echo "Error: No se puede leer el archivo de capacidad de la batería."
          continue
        fi

        case $battery_status in
          "Full" )
            [ "$notified_full" = false ] && notify "battery-full.svg" "Batería llena" "100%"
            reset_flags
            ;;

          "Discharging" )
            if [ "$battery_capacity" -le 5 ]; then
              [ "$notified_critical" = false ] && notify "battery-warning.svg" "Batería crítica" "$battery_capacity%"
              reset_flags
            elif [ "$battery_capacity" -le 25 ]; then
              [ "$notified_low" = false ] && notify "battery-25.svg" "Batería baja" "$battery_capacity%"
              reset_flags
            fi
            ;;

          "Charging" )
            [ "$notified_charging" = false ] && notify "battery-charging.svg" "Cargando" "$battery_capacity%"
            reset_flags
            ;;

          * )
            # Otros estados (puedes manejarlos según sea necesario)
            reset_flags
            ;;
        esac
        ;;
      * )
        echo "Error: Archivo desconocido modificado - $changed_file"
        ;;
    esac
  done
done
