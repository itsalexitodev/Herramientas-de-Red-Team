⚠️ **¡Advertencia! Esta herramienta ha sido creada con fines educativos. El creador no se hace responsable del mal uso de la misma. Utilízala bajo tu propia responsabilidad.**

# Network Scanner

Este script escanea una red y muestra los dispositivos activos utilizando la biblioteca scapy para enviar paquetes ARP y recibir respuestas. Está disponible en dos versiones: línea de comandos (CLI) y una interfaz gráfica de usuario (GUI) desarrollada con tkinter.

## Requisitos
- Python 3.x
- Paquetes Python: tabulate, scapy

## Instalación
Asegúrate de tener Python 3.x instalado. Si no lo tienes, descárgalo desde el sitio web oficial de Python.

Instala los paquetes requeridos ejecutando estos comandos en la terminal:


`pip install tabulate scapy`


## Uso

### Interfaz de línea de comandos (CLI)
Ejecuta el script `network_scanner.py` con Python 3:

`python network_scanner.py`


Ingresa tu dirección de red en formato CIDR cuando se solicite:

Asegúrate de ingresar una dirección de red válida.


El script comenzará a escanear los dispositivos activos en la red.

Los resultados se mostrarán en una tabla con las columnas "IP" y "MAC". La tabla se actualizará automáticamente cada 10 segundos.

Puedes detener el escaneo presionando Ctrl+C.

### Interfaz gráfica de usuario (GUI)
Ejecuta el script `network_scanner_gui.py` con Python 3:

`python network_scanner_gui.py`

Se abrirá una ventana de GUI.

Ingresa tu dirección de red en formato CIDR en el campo correspondiente.

Haz clic en el botón "Escanear" para comenzar el escaneo de la red.

Los resultados se mostrarán en una tabla en la ventana. La tabla se actualizará automáticamente cada 10 segundos.

Para detener el escaneo, haz clic en el botón "Salir" o cierra la ventana.

## Notas adicionales
- Este script requiere privilegios de administrador, ya que utiliza funciones de escaneo de red de bajo nivel.
- Durante el escaneo, se envían paquetes ARP a cada dirección IP de la red y se espera una respuesta. El tiempo de espera predeterminado es de 3 segundos.
- Si no se encuentran dispositivos activos en la red, se mostrará un mensaje correspondiente.
- En la versión GUI, se utiliza la biblioteca tkinter para crear la ventana y los elementos de la interfaz.
- Puedes detener el escaneo en cualquier momento presionando Ctrl+C en la versión CLI o haciendo clic en el botón "Salir" en la versión GUI.
- Algunos sistemas operativos pueden requerir permisos de administrador para ejecutar el script correctamente.

¡Disfruta del escaneo de red! Si tienes alguna pregunta, no dudes en contactarnos.
