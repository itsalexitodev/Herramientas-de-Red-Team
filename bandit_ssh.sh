#!/bin/bash

# Variables de configuración
username="bandit0"
hostname="bandit.labs.overthewire.org"
port="2220"

# Bucle para conectar a cada nivel
for level in {0..21}; do
    echo "Conectando al nivel $level..."
    password="bandit$level" # Contraseña para el nivel actual

    # Comando de conexión SSH
    sshpass -p "$password" ssh -q -p "$port" "$username@$hostname" "echo 'Conectado al nivel $level'; bash"

    echo "Desconectado del nivel $level."
done

echo "Proceso completado."
