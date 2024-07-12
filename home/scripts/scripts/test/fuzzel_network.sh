#!/bin/bash

# Define el directorio que contiene las imágenes
DIRECTORIO_IMAGENES="$HOME/Wallpapers"

# Función para mostrar miniaturas de imágenes
mostrar_imagenes() {
    local carpeta="$1"
    # Encuentra imágenes en la carpeta
    imagenes=$(find "$carpeta" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | sort)

    # Verifica si se encontraron imágenes
    if [ -z "$imagenes" ]; then
        yad --error --text="No se encontraron imágenes en la carpeta seleccionada."
        return 1
    fi

    # Genera una lista de miniaturas y rutas
    miniaturas=""
    for imagen in $imagenes; do
        miniatura=$(mktemp /tmp/miniatura_XXXXX.png)
        if mogrify -path /tmp -thumbnail 100x100 -format png -write "$miniatura" "$imagen"; then
            miniaturas+="$miniatura $imagen "
        else
            rm -f "$miniatura"
        fi
    done

    # Verifica si se generaron miniaturas
    if [ -z "$miniaturas" ]; then
        yad --error --text="Hubo un problema generando las miniaturas."
        return 1
    fi

    # Muestra las imágenes en un cuadro de diálogo de iconos
    imagen_seleccionada=$(yad --file --multiple --height=500 --width=800 \
        --title="Seleccione una imagen" \
        --list --separator="," \
        --column="Miniatura:IMG" --column="Imagen" \
        $(echo "$miniaturas"))

    # Limpia las miniaturas generadas
    for miniatura in $miniaturas; do
        rm -f "$(echo $miniatura | cut -d ' ' -f1)"
    done

    # Verifica si se seleccionó una imagen
    if [ -z "$imagen_seleccionada" ]; then
        return 1
    fi

    # Separa la imagen seleccionada
    ruta_imagen=$(echo "$imagen_seleccionada" | cut -d '|' -f2)

    # Establece la imagen seleccionada como fondo de pantalla usando swaybg
    swaybg -i "$ruta_imagen" &

    return 0
}

# Verifica si el directorio existe
if [ ! -d "$DIRECTORIO_IMAGENES" ]; then
    yad --error --text="El directorio de imágenes no existe: $DIRECTORIO_IMAGENES"
    exit 1
fi

# Muestra las imágenes en el directorio predefinido y permite al usuario seleccionar una para establecerla como fondo de pantalla
mostrar_imagenes "$DIRECTORIO_IMAGENES"
