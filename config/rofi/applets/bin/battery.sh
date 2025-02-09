#!/usr/bin/env bash

## Autor  : Aditya Shakya (adi1090x)
## Github  : @adi1090x
#
## Applets : Batería

# Importar Tema Actual
source "$HOME"/.config/rofi/applets/shared/theme.bash
theme="$type/$style"

# Información de la Batería
battery="`acpi -b | cut -d',' -f1 | cut -d':' -f1`"
status="`acpi -b | cut -d',' -f1 | cut -d':' -f2 | tr -d ' '`"
percentage="`acpi -b | cut -d',' -f2 | tr -d ' ',\%`"
time="`acpi -b | cut -d',' -f3`"

if [[ -z "$time" ]]; then
	time=' Completamente Cargada'
fi

# Elementos del Tema
prompt="$status"
mesg="${battery}: ${percentage}%,${time}"

# Ajustes de ventana para efecto glass
win_width='400px'
win_radius='20px'
win_opacity='70%' # Ajuste de opacidad para efecto glass

# Estado de Carga
active=""
urgent=""
if [[ $status = *"Cargando"* ]]; then
    active="-a 1"
    ICON_CHRG=""
elif [[ $status = *"Completa"* ]]; then
    active="-u 1"
    ICON_CHRG=""
else
    urgent="-u 1"
    ICON_CHRG=""
fi

# Descarga
ICON_DISCHRG="" # Icono por defecto para simplificar
if [[ $percentage -le 20 ]]; then
    ICON_DISCHRG=""
elif [[ $percentage -le 40 ]]; then
    ICON_DISCHRG=""
elif [[ $percentage -le 60 ]]; then
    ICON_DISCHRG=""
elif [[ $percentage -le 80 ]]; then
    ICON_DISCHRG=""
fi

# Opciones
layout=`cat ${theme} | grep 'USE_ICON' | cut -d'=' -f2`
if [[ "$layout" == 'NO' ]]; then
	option_1=" Restante ${percentage}%"
	option_2=" $status"
	option_3=" Gestor de Energía"
	option_4=" Diagnóstico"
else
	option_1="$ICON_DISCHRG"
	option_2="$ICON_CHRG"
	option_3=""
	option_4=""
fi

# Comando Rofi
rofi_cmd() {
	rofi -theme-str "window {width: $win_width; border-radius: $win_radius; opacity: $win_opacity;}" \
		-dmenu \
		-p "$prompt" \
		-mesg "$mesg" \
		${active} ${urgent} \
		-markup-rows \
		-theme "${theme}"
}

# Pasar variables a rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4" | rofi_cmd
}

# Ejecutar Comando
run_cmd() {
	polkit_cmd="pkexec env PATH=$PATH DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY"
	if [[ "$1" == '--opt1' ]]; then
		notify-send -u low " Restante : ${percentage}%"
	elif [[ "$1" == '--opt2' ]]; then
		notify-send -u low "$ICON_CHRG Estado : $status"
	elif [[ "$1" == '--opt3' ]]; then
		xfce4-power-manager-settings
	elif [[ "$1" == '--opt4' ]]; then
		${polkit_cmd} alacritty -e powertop
	fi
}

# Acciones
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
esac

