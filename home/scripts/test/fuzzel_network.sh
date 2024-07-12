#!/bin/bash

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

    # Muestra las imágenes en un cuadro de diálogo de iconos
    imagen_seleccionada=$(yad --file --multiple --height=500 --width=800 \
                            --title="Seleccione una imagen" \
                            --preview --image-width=200 --image-height=200 \
                            --column="Imagen" --column="Ruta" \
                            --list --separator="," \
                            $(echo "$imagenes" | while read -r imagen; do
                                # Genera miniaturas usando convert de ImageMagick
                                miniatura=$(mktemp /tmp/miniatura_XXXXX.png)
                                convert -resize 100x100 "$imagen" "$miniatura"
                                echo "$miniatura" "$imagen"
                            done))

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

# Selecciona una carpeta que contiene las imágenes
carpeta=$(yad --file --directory --title="Seleccione la carpeta de imágenes")

# Verifica si se seleccionó una carpeta
if [ -z "$carpeta" ]; then
    yad --error --text="No se seleccionó ninguna carpeta."
    exit 1
fi

# Muestra las imágenes en la carpeta seleccionada y permite al usuario seleccionar una para establecerla como fondo de pantalla
mostrar_imagenes "$carpeta"
