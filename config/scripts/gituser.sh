#!/bin/bash

# Verificar si ya tienes una clave SSH configurada
ssh-keygen

# Agregar la clave SSH al ssh-agent
ssh-add ~/.ssh/id_ed25519 #esto es un ejemplo

# Imprime el mensaje para agregar la clave SSH a tu cuenta de GitHub
echo "Por favor, copia la siguiente clave SSH y agrégala a tu cuenta de GitHub:"
echo ""
cat ~/.ssh/id_ed25519.pub #esto es un ejemplo
echo ""

# Abrir la página de configuración de claves SSH en GitHub
echo "Luego ve a https://github.com/settings/keys para agregar la clave SSH a tu cuenta de GitHub."

# Esperar hasta que el usuario confirme que ha agregado la clave SSH a su cuenta de GitHub
read -r "Presiona Enter una vez que hayas agregado la clave SSH a tu cuenta de GitHub."

# Probar la conexión SSH a GitHub
echo "Probando la conexión SSH a GitHub..."
ssh -T git@github.com

# Configurar el repositorio git para usar SSH
git remote set-url origin git@github.com:Shidohs/tu_repositorio.git

# Realizar un git push para verificar si la configuración de SSH funciona
echo "Probando el git push con la configuración de SSH..."
git push origin main

echo "Listo. Ahora deberías poder hacer 'git push' sin ingresar tu nombre de usuario y contraseña."





