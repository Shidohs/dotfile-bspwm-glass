#!/bin/bash

get_battery_info() {
  # shellcheck disable=SC2046
  battery_percentage=$(upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}' | cut -d'%' -f1)
  # shellcheck disable=SC2046
  status=$(upower -i $(upower -e | grep 'BAT') | grep state | awk '{print $2}')
  echo "$battery_percentage|$status"
}


screen_battery() {
  info=$(get_battery_info)

  battery_percentage=$(echo "$info" | cut -d'|' -f1)
  status=$(echo "$info" | cut -d'|' -f2)
   # Corrección para evitar el problema de tipo booleano esperado vs entero
  battery_percentage=$(echo "$battery_percentage" | awk '{printf("%d\n", $1)}')

 #icons
  full_icon_battery=" "
  high_icon_battery=" "
  medium_icon_battery=" "
  low_icon_battery=" "
  very_low_icon_battery=" "
  charging_icon_battery=" "
  icon=" 󱐋"
 # resetear el icon de battery cada que se actualiza el status
  if [ "$status" = "charging" ]; then
    icon=$charging_icon_battery
  elif [ "$battery_percentage" -ge 80 ] && [ "$battery_percentage" -lt 100 ]; then
    icon=$full_icon_battery
  elif [ "$battery_percentage" -ge 60 ] && [ "$battery_percentage" -lt 80 ]; then
    icon=$high_icon_battery
  elif [ "$battery_percentage" -ge 40 ] && [ "$battery_percentage" -lt 60 ]; then
    icon=$medium_icon_battery
  elif [ "$battery_percentage" -ge 20 ] && [ "$battery_percentage" -lt 40 ]; then
    icon=$low_icon_battery
  elif [ "$battery_percentage" -ge 10 ] && [ "$battery_percentage" -lt 20 ]; then
    icon=$very_low_icon_battery
  fi
 # pending-charge: es un estado donde detecta bateria pero no carga
  if [ "$status" = "pending-charge" ]; then
    icon=" 󱃍"
    echo "$icon"
  # si el estato esta vacio imprimir el icono de solo cargando
  elif [ -z "$status" ]; then
    echo "$icon"
  else
    echo "$icon ${battery_percentage}%"
  fi
  
}

if [ "$1" == "--status" ]; then
  screen_battery
fi


