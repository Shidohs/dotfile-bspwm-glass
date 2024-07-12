#!/bin/bash

# Establecer el tiempo de espera en segundos (1 hora y media = 5400 segundos)
tiempo_espera=5400

# Mostrar un mensaje de confirmación
echo "La computadora se apagará en $tiempo_espera segundos (1 hora y media)."
echo "Si deseas cancelar el apagado, presiona Ctrl+C."

# Esperar el tiempo especificado
sleep $tiempo_espera

# Apagar la computadora
shutdown -h now

