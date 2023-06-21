#!/bin/bash

# Verificar si el script se está ejecutando como administrador
if [ "$(id -u)" != "0" ]; then
    echo "Este script debe ejecutarse como administrador (root)." >&2
    exit 1
fi

# Actualizar lista de paquetes
apt update

# Instalar kali-win-kex
apt install -y kali-win-kex

# Instalar kali-linux-large
apt install -y kali-linux-large

# Mostrar mensaje de finalización
echo "¡Los paquetes kali-win-kex y kali-linux-large han sido instalados exitosamente!"

exit 0
