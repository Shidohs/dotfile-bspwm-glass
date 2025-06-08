#!/bin/bash

# Ruta a los colores generados por pywal
WAL_COLORS="$HOME/.cache/wal/colors"

# Verificar si el archivo de colores existe
if [ ! -f "$WAL_COLORS" ]; then
    echo "Error: No se encontró el archivo de colores de pywal"
    exit 1
fi

# Leer los colores (pywal siempre genera 16)
readarray -t colors < "$WAL_COLORS"

# Generar config con los colores dinámicos
cat > "$HOME/.config/dunst/dunstrc" <<EOF
[global]
font = Roboto Medium 14
transparency = 12
corner_radius = 12
frame_width = 0  # Esto quita los marcos
separator_height = 2
separator_color = "${colors[8]}"
icon_position = left
stack_duplicates = false
monitor = 0
follow = mouse
origin = top-right
offset = (50, 50)
width = 500
height = (0, 160)
background = "${colors[0]}CC"
foreground = "${colors[7]}"
frame_color = "${colors[5]}"
enable_recursive_icon_lookup = true
icon_path = /usr/share/icons/candy-icons

[urgency_low]
timeout = 4
background = "${colors[0]}AA"
foreground = "${colors[7]}"
frame_color = "${colors[8]}"

[urgency_normal]
timeout = 8
background = "${colors[0]}CC"
foreground = "${colors[7]}"
frame_color = "${colors[5]}"

[urgency_critical]
timeout = 0
background = "${colors[1]}CC"
foreground = "${colors[15]}"
frame_color = "${colors[1]}"
EOF

# Asegurarse que Dunst está completamente detenido
killall -q dunst || true
sleep 1

# Iniciar Dunst desvinculado de la terminal
setsid dunst >/dev/null 2>&1 &
disown

# Esperar un poco para que Dunst se inicie
sleep 1

# Salir explícitamente con éxito
exit 0
