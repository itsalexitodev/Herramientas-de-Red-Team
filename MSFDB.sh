#!/bin/bash

# Ruta del archivo de base de datos
database_file="/root/.msf4/database.yml"

# Verificar si el archivo de base de datos existe
if [ ! -f "$database_file" ]; then
    echo "El archivo de base de datos no existe. Creando..."
    # Copiar el archivo de configuración de la base de datos
    cp /usr/share/metasploit-framework/config/database.yml "$database_file"
fi

# Eliminar la base de datos existente
msfdb delete

# Inicializar la base de datos
msfdb init

# Reiniciar el servicio de PostgreSQL
service postgresql restart

