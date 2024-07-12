#!/bin/bash

# Función para obtener el consumo de RAM y CPU de una aplicación
function monitor_app {
    local app_name=$1
    echo "Monitoreando $app_name..."

    # Obtener el consumo de RAM y CPU de todos los procesos con el nombre de la aplicación
    ps -C "$app_name" -o pid=,rss=,pcpu= --no-headers | while read pid rss pcpu; do
        echo "PID: $pid, RAM: $((rss/1024)) MB, CPU: $pcpu%"
    done

    echo "----------------------------------------"
}

# Verificar si se proporcionaron argumentos
if [ $# -eq 0 ]; then
    echo "Uso: $0 [nombre_app1] [nombre_app2]"
    exit 1
fi

# Monitorear las aplicaciones proporcionadas como argumentos
for app in "$@"; do
    monitor_app "$app"
done
