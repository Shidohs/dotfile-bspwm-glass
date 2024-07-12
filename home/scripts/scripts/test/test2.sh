#!/bin/bash

# Definición de funciones
install() {
    local comando=$1
    $comando
}

salir() {
    exit
}

# Arreglo asociativo para comandos
declare -A commands=(
    ["Instalar"]="install ''"
    ["Visualizar Código"]="visualizar_codigo ''"
    ["Salir"]="salir"
)

# Función para mostrar el menú y manejar la selección
show_menu() {
    local title=$1
    local -a options=("${!2}")
    local selected=0

    while true; do
        clear
        echo "$title"
        echo "Seleccione una opción:"
        for i in "${!options[@]}"; do
            if [[ $i -eq $selected ]]; then
                echo "-> ${options[$i]}"
            else
                echo "   ${options[$i]}"
            fi
        done

        # Leer la entrada del usuario
        read -rsn1 input
        case $input in
        A)
            selected=$((selected - 1))
            if [[ $selected -lt 0 ]]; then selected=${#options[@]}-1; fi
            ;;
        B)
            selected=$((selected + 1))
            if [[ $selected -ge ${#options[@]} ]]; then selected=0; fi
            ;;
        "") break ;;
        esac
    done

    # Ejecutar la función o comando asociado a la opción seleccionada
    eval "${commands[${options[$selected]}]}"
}

# COMIENZO DEL SCRIPTS DE INSTALACION

# actualizar sistema
commands["Instalar"]="install 'sudo pacman -Syu'"
options=("Instalar" "Omitir" "Salir")
show_menu "---- ACTUALIZAR SISTEMA ----" options[@]
clear

# instalar zsh
commands["Instalar"]="install 'sudo pacman -S zsh'"
options=("Instalar" "Omitir" "Salir")
show_menu "---- INSTALAR ZSH ----" options[@]
clear
