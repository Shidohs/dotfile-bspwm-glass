#!/bin/bash
# Mata cualquier instancia de xautolock que pueda estar ejecutándose
pkill -f xautolock

# Inicia xautolock con betterlockscreen como bloqueador de pantalla
# Configura xautolock para bloquear la pantalla después de 5 minutos de inactividad
# Configura xautolock para suspender el sistema después de 5 minutos de estar bloqueado
xautolock -time 15 -locker "betterlockscreen -l" -notify 30 -notifier "notify-send 'Locker' 'Locking screen in 30 seconds'" -killtime 30 -killer "systemctl suspend" &
