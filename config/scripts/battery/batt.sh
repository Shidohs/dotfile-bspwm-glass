#!/bin/bash

get_battery_info() {

  capacidad_entera=$(upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}' | cut -d'%' -f1)
  status=$(upower -i $(upower -e | grep 'BAT') | grep state | awk '{print $2}')

  echo "$capacidad_entera|$status"
}


screen_battery() {
  info=$(get_battery_info)

  capacidad_entera=$(echo "$info" | cut -d'|' -f1)
  status=$(echo "$info" | cut -d'|' -f2)
   # Corrección para evitar el problema de tipo booleano esperado vs entero
  capacidad_entera=$(echo "$capacidad_entera" | awk '{printf("%d\n", $1)}')

  full_icon_battery=""
  high_icon_battery=""
  medium_icon_battery=""
  low_icon_battery=""
  charging_icon_battery=""
  very_low_icon_battery=""
  icon=$default_icon



  if [ "$status" = "charging" ]; then
    icon=$charging_icon_battery
  elif [ "$capacidad_entera" -ge 80 ] && [ "$capacidad_entera" -lt 100 ]; then
    icon=$full_icon_battery
  elif [ "$capacidad_entera" -ge 60 ] && [ "$capacidad_entera" -lt 80 ]; then
    icon=$high_icon_battery
  elif [ "$capacidad_entera" -ge 40 ] && [ "$capacidad_entera" -lt 60 ]; then
    icon=$medium_icon_battery
  elif [ "$capacidad_entera" -ge 20 ] && [ "$capacidad_entera" -lt 40 ]; then
    icon=$low_icon_battery
  else
    icon=$very_low_icon_battery
  fi


  echo "$icon ${capacidad_entera}%"
}

if [ "$1" == "--status" ]; then
  screen_battery
fi
