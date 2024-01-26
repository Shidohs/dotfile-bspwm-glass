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

while true; do

  battery_status=$(cat /sys/class/power_supply/BAT*/status)
  battery_capacity=$(cat /sys/class/power_supply/BAT*/capacity)

  # Batería llena
  if [ "$battery_status" = "Full" ] && [ "$notified_full" = false ]; then
    notify "battery-full.svg" "Batería llena" "100%"
    notified_full=true

  # Batería baja  
  elif [ "$battery_status" = "Discharging" ] && [ "$battery_capacity" -le 25 ] && [ "$notified_low" = false ]; then
    notify "battery-25.svg" "Batería baja" "$battery_capacity%"
    notified_low=true

  # Batería crítica
  elif [ "$battery_status" = "Discharging" ] && [ "$battery_capacity" -le 5 ] && [ "$notified_critical" = false ]; then
    notify "battery-warning.svg" "Batería crítica" "$battery_capacity%"
    notified_critical=true

  # Cargando
  elif [ "$battery_status" = "Charging" ] && [ "$notified_charging" = false ]; then
    notify "battery-charging.svg" "Cargando" "$battery_capacity%"
    notified_charging=true

  # Desconectado
  elif [ "$battery_status" = "Discharging" ] && [ "$notified_disconnected" = false ]; then  
    notify "battery-empty.svg" "Cargador desconectado"
    notified_disconnected=true

  fi

  # Verificar cada 5 minutos
  sleep 300
done

