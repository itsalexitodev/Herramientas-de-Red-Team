#!/bin/bash

while true; do
    # Solicitar al usuario que introduzca el dominio
    read -p "Introduce un dominio (o 'q' para salir): " dominio

    # Verificar si el usuario desea salir
    if [ "$dominio" == "q" ]; then
        echo "Saliendo del programa."
        break
    fi

    # Solicitar al usuario que introduzca tipos de registros (separados por espacios)
    read -p "Introduce los tipos de registros (opcional, separados por espacios): " tipos_de_registros

    # Crear un arreglo de tipos de registros separados por espacios
    IFS=" " read -ra tipos_de_registros_array <<< "$tipos_de_registros"

    # Ejecutar nslookup con los tipos de registros (si se proporcionan)
    if [ -n "$tipos_de_registros" ]; then
        for tipo_de_registro in "${tipos_de_registros_array[@]}"; do
            nslookup -q="$tipo_de_registro" "$dominio"
        done
    else
        nslookup "$dominio"
    fi
done
