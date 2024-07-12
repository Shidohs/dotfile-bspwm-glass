#!/bin/bash

# Directorio que contiene las imágenes
DIRECTORIO_IMAGENES="$HOME/Wallpapers"

# Directorio temporal para las miniaturas
DIRECTORIO_MINIATURAS="/tmp/miniaturas_wallpapers"

# Crear el directorio temporal si no existe
mkdir -p "$DIRECTORIO_MINIATURAS"

# Limpiar miniaturas anteriores
rm -f "$DIRECTORIO_MINIATURAS"/*

# Generar miniaturas
for imagen in "$DIRECTORIO_IMAGENES"/*.{jpg,jpeg,png}; do
    if [ -f "$imagen" ]; then
        miniatura="$DIRECTORIO_MINIATURAS/$(basename "$imagen")"
        mogrify -path "$DIRECTORIO_MINIATURAS" -thumbnail 100x100 -format png -write "$miniatura" "$imagen"
    fi
done

# Generar lista de imágenes para fuzzel
lista_imagenes=$(ls "$DIRECTORIO_MINIATURAS"/*.png | xargs -I {} basename {})

# Mostrar imágenes usando fuzzel
seleccion=$(echo "$lista_imagenes" | fuzzel -d -p "Seleccione un fondo: ")

# Verificar si se seleccionó una imagen
if [ -n "$seleccion" ]; then
    imagen_original="$DIRECTORIO_IMAGENES/$seleccion"
    if [ -f "$imagen_original" ]; then
        swaybg -i "$imagen_original" &
        notify-send "Gestor de Wallpapers" "Fondo de pantalla cambiado a $seleccion"
    else
        notify-send "Error" "La imagen seleccionada no se encuentra en el directorio original."
    fi
else
    notify-send "Gestor de Wallpapers" "No se seleccionó ninguna imagen."
fi
