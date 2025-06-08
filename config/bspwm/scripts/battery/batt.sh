#!/bin/bash

# Obtener información de la batería
batteryInfoJSon="$HOME/.config/bspwm/scripts/battery/battery_info.json"
battery_percentage=$(upower -i "$(upower -e | grep 'BAT')" | grep percentage | awk '{print $2}' | cut -d'%' -f1)
status=$(upower -i "$(upower -e | grep 'BAT')" | grep state | awk '{print $2}')

# Leer el archivo JSON y obtener los valores previos
if [ -f "$batteryInfoJSon" ]; then
  old_battery_percentage=$(jq -r '.battery_percentage' "$batteryInfoJSon")
  old_status=$(jq -r '.status' "$batteryInfoJSon")
else
  old_battery_percentage=""
  old_status=""
fi

# Verificar si el porcentaje o el estado han cambiado
if [ "$battery_percentage" != "$old_battery_percentage" ] || [ "$status" != "$old_status" ]; then
  # Si hay un cambio, actualizar el archivo JSON
  echo "{\"battery_percentage\": \"$battery_percentage\", \"status\": \"$status\"}" >"$batteryInfoJSon"
fi

# Función para obtener información desde el archivo JSON
get_battery_info() {
  battery_info=$(cat "$batteryInfoJSon")
  battery_percentage=$(echo "$battery_info" | jq -r '.battery_percentage')
  status=$(echo "$battery_info" | jq -r '.status')
}

# Función para mostrar el icono correspondiente al estado de la batería
screen_battery() {
  # Obtener la información actual de la batería
  get_battery_info

  # Icons battery
  full_icon_battery="  "
  high_icon_battery="  "
  medium_icon_battery="  "
  low_icon_battery="  "
  very_low_icon_battery="  "
  charging_icon_battery="  "
  pending_charge_icon=" 󱃍 "
  icon="  "

  # Asignación de íconos según el estado de la batería
  case "$status" in
  "charging")
    icon=$charging_icon_battery
    ;;
  "discharging")
    if [ "$battery_percentage" -ge 90 ]; then
      icon=$full_icon_battery
    elif [ "$battery_percentage" -ge 75 ]; then
      icon=$high_icon_battery
    elif [ "$battery_percentage" -ge 50 ]; then
      icon=$medium_icon_battery
    elif [ "$battery_percentage" -ge 25 ]; then
      icon=$low_icon_battery
    elif [ "$battery_percentage" -ge 10 ]; then
      icon=$very_low_icon_battery
    else
      icon=$low_icon_battery
    fi
    ;;
  "empty")
    icon=$very_low_icon_battery
    ;;
  "full")
    icon=$full_icon_battery
    ;;
  "pending-charge")
    icon="$pending_charge_icon"
    ;;
  *)
    icon="  ON "
    ;;
  esac

  echo "$icon"
}

# Ejecutar la función screen_battery si se pasa el parámetro --status
if [ "$1" == "--status" ]; then
  screen_battery
fi
