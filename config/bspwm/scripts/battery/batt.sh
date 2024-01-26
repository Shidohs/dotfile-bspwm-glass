#!/bin/bash

get_battery_info() {

  capacity=$(upower -i $(upower -e | grep 'BAT') | grep percentage | awk '{print $2}' | cut -d'%' -f1)
  status=$(upower -i $(upower -e | grep 'BAT') | grep state | awk '{print $2}')

  echo "$capacity|$status"
}


print_battery() {
  info=$(get_battery_info)

  capacity=$(echo "$info" | cut -d'|' -f1)
  status=$(echo "$info" | cut -d'|' -f2)

  full_icon_battery=""
  high_icon_battery=""
  medium_icon_battery=""
  low_icon_battery=""
  charging_icon_battery=""
  very_low_icon_battery=""
  icon=$default_icon

  if [ "$status" = "charging" ]; then
    icon=$charging_icon_battery
  elif [ "$capacity" -ge 80 ] && [ "$capacity" -lt 100 ]; then
    icon=$full_icon_battery
  elif [ "$capacity" -ge 60 ] && [ "$capacity" -lt 80 ]; then
    icon=$high_icon_battery
  elif [ "$capacity" -ge 40 ] && [ "$capacity" -lt 60 ]; then
    icon=$medium_icon_battery
  elif [ "$capacity" -ge 20 ] && [ "$capacity" -lt 40 ]; then
    icon=$low_icon_battery
  else
    icon=$very_low_icon_battery
  fi





  echo "$icon $capacity%"
}


if [ "$1" == "--status" ]; then
  print_battery
fi