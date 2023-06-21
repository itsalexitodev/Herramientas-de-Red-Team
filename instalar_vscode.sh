#!/bin/bash

# Verificar si el script se está ejecutando como administrador
if [ "$(id -u)" != "0" ]; then
    echo "Este script debe ejecutarse como administrador (root)." >&2
    exit 1
fi

# Descargar el paquete .deb de Visual Studio Code
wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"

# Instalar el paquete .deb de Visual Studio Code
dpkg -i vscode.deb

# Instalar dependencias faltantes (si es necesario)
apt install -f -y

# Eliminar el archivo .deb descargado
rm vscode.deb

# Mostrar mensaje de finalización
echo "Visual Studio Code ha sido instalado exitosamente en tu sistema."

exit 0
