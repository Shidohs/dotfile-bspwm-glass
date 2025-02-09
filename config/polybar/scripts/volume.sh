#!/bin/bash

# Ruta para el archivo temporal que indica que la barra está activa
BAR_FILE="/tmp/polybar_volume_bar"

# Función para obtener el volumen actual
get_volume() {
    amixer get Master | grep -oP "\[\d+%\]" | head -n 1 | tr -d '[]%'
}

# Función para mostrar solo el icono de volumen
icon_only() {
    local volume=$(get_volume)
    if amixer get Master | grep -q "\[off\]"; then
        echo "󰖁" # Icono de volumen silenciado
    else
        if [ "$volume" -lt 30 ]; then
            echo "󰕿" # Bajo volumen
        elif [ "$volume" -lt 70 ]; then
            echo "󰖀" # Volumen medio
        else
            echo "󰕾" # Volumen alto
        fi
    fi
}

# Función para mostrar la barra de volumen
show_bar() {
    local volume=$(get_volume)
    local bar=""
    local bar_length=20 # Longitud de la barra

    # Calcular el número de bloques de la barra basados en el volumen
    local filled_blocks=$((volume / 5))
    local empty_blocks=$((bar_length - filled_blocks))

    # Construir la barra visual
    bar=$(printf "█%.0s" $(seq 1 $filled_blocks))
    bar+=$(printf "░%.0s" $(seq 1 $empty_blocks))

    # Mostrar la barra con el porcentaje de volumen
    echo "$bar $volume%"
}

# Función para alternar entre el icono y la barra
toggle_volume() {
    if [ -f "$BAR_FILE" ]; then
        rm "$BAR_FILE"
        icon_only
    else
        touch "$BAR_FILE"
        show_bar
    fi
}

# Procesar los argumentos
case "$1" in
--icon-only) icon_only ;;
--show-bar) show_bar ;;
--toggle-volume) toggle_volume ;;
esac
