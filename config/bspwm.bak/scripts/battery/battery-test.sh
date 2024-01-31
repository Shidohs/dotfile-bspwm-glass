
#!/bin/bash

# Directorio de iconos
icon_dir="$HOME/.config/bspwm/assets/battery"

# Último porcentaje notificado  
last_percent=100

# Último estado notificado
last_status="Unknown"

# Obtener información de batería
battery=$(upower -i $(upower -e | grep BAT))

# Función para obtener capacidad
get_capacity() {

  capacity=$(echo "$battery" | grep --color=never -E percentage | xargs | cut -d' ' -f2)

}

# Función para obtener estado
get_status() {

  status=$(echo "$battery" | grep --color=never -E state)

}

# Manejador de eventos  
handle_event() {

  get_capacity
  get_status

  # Convertir % a entero 
  capacity=$(echo "$capacity" | sed 's/%//')

  # Verificar y notificar cambios de capacidad y estado
  if [ $capacity -eq 100 ] && [ $last_percent -ne 100 ]; then
    notify="-i $icon_dir/battery-full.svg Batería llena"

  elif [ $capacity -le 25 ] && [ $last_percent -gt 25 ]; then  
    notify="-i $icon_dir/battery-25.svg Batería baja $capacity%"

    # Batería crítica    
  elif [ $capacity -le 5 ] && [ $last_percent -gt 5 ]; then
    notify="-i $icon_dir/battery-warning.svg Batería crítica $capacity%"

  elif [ "$status" = "Charging" ] && [ "$last_status" = "Discharging" ]; then
    notify="-i $icon_dir/charger-connected.svg Cargador conectado"


  # Cargador desconectado
  elif [ "$status" = "Discharging" ] && [ "$last_status" = "Charging" ]; then
    notify="-i $icon_dir/charger-disconnected.svg Cargador desconectado"
  fi

  # Mostrar notificación
  if [ ! -z "$notify" ]; then
    dunstify ${notify}
  fi

  # Guardar últimos valores
  last_percent=$capacity
  last_status=$status

}

# Monitor de eventos
upower --monitor-detail=battery --timeout=10 | while read -r event; do

  handle_event

done

# Verificar cada 60 segundos
#sleep 60