#!/bin/bash

# Nombre del script
Script_Wall=$(basename "$0")

# Directorio de fondos de pantalla
WALL_DIR="$HOME/Wallpapers"

# Archivo para registrar los últimos fondos usados
HISTORY_FILE="/tmp/wallpaper_history.txt"

# Número de sesiones a evitar repetir fondos
HISTORY_LIMIT=5

# Función para matar instancias anteriores del script y de feh
kill_previous_instances() {
    local pids=$(pgrep -fx "/bin/bash $0")
    for pid in $pids; do
        if [ "$pid" != "$$" ]; then
            kill -9 "$pid"
        fi
    done

    # Matar cualquier instancia previa de feh
    pkill feh
}

# Ejecutar la función para matar instancias anteriores
kill_previous_instances

# Cambiar el fondo de pantalla aleatoriamente, evitando repeticiones
change_wallpaper() {
    local wallpapers=("$WALL_DIR"/*)
    if [ ${#wallpapers[@]} -eq 0 ]; then
        echo "No se encontraron fondos de pantalla en $WALL_DIR."
        exit 1
    fi

    # Cargar historial de fondos usados
    local history=()
    if [ -f "$HISTORY_FILE" ]; then
        mapfile -t history < "$HISTORY_FILE"
    fi

    # Filtrar fondos disponibles
    local available=()
    for wallpaper in "${wallpapers[@]}"; do
        if [[ ! " ${history[*]} " =~ " $wallpaper " ]]; then
            available+=("$wallpaper")
        fi
    done

    # Si todos los fondos están en el historial, reiniciar la lista
    if [ ${#available[@]} -eq 0 ]; then
        available=("${wallpapers[@]}")
    fi

    # Seleccionar un fondo aleatorio
    local wallpaper=$(shuf -n 1 -e "${available[@]}")
    feh --bg-scale "$wallpaper" &

    # Actualizar historial
    history+=("$wallpaper")
    if [ ${#history[@]} -gt $HISTORY_LIMIT ]; then
        history=("${history[@]: -$HISTORY_LIMIT}")
    fi
    printf "%s\n" "${history[@]}" > "$HISTORY_FILE"
}

# Ejecutar el cambio de fondo y luego repetir cada 30 minutos
change_wallpaper
while sleep 1800; do
    change_wallpaper
done
