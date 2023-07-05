#!/bin/bash

#Eliminar la base de datos existente
msfdb delete

# Inicializar la base de datos
msfdb init

# Copiar el archivo de configuración de la base de datos
cp /usr/share/metasploit-framework/config/database.yml /root/.msf4/

# Reiniciar el servicio de PostgreSQL
service postgresql restart

# Iniciar Metasploit Framework nuevamente
msfconsole
