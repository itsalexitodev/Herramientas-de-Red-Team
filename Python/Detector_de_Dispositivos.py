import scapy.all as scapy

def validar_direccion_ip(ip):
    octetos = ip.split(".")
    
    # Verificar la cantidad de octetos
    if len(octetos) != 4:
        return False
    
    # Verificar que cada octeto sea un número válido entre 0 y 255
    for octeto in octetos:
        if not octeto.isdigit() or int(octeto) > 255:
            return False
    
    # Verificar que el último octeto no sea 255 ni 1
    if octetos[3] == "255" or octetos[3] == "1":
        return False
    
    return True

def obtener_direccion_red(ip):
    octetos = ip.split(".")
    octetos[-1] = "0"  # Establecer el último octeto como 0 para obtener la dirección de red
    direccion_red = ".".join(octetos)
    return direccion_red

def scan_network(ip):
    arp_request = scapy.ARP(pdst=ip)
    broadcast = scapy.Ether(dst="ff:ff:ff:ff:ff:ff")
    arp_request_broadcast = broadcast/arp_request
    answered_list = scapy.srp(arp_request_broadcast, timeout=1, verbose=False)[0]
    
    active_devices = []
    for element in answered_list:
        device = {"ip": element[1].psrc, "mac": element[1].hwsrc}
        active_devices.append(device)
    
    return active_devices

# Solicitar al usuario la dirección de red
direccion_red = input("Ingresa tu dirección de red: ")

# Validar la dirección de red ingresada
if not validar_direccion_ip(direccion_red):
    print("La dirección de red", direccion_red, "no es válida")
    exit()

# Obtener la dirección de red completa
target_ip = obtener_direccion_red(direccion_red)

active_devices = scan_network(target_ip)

print("Dispositivos activos en la red:")
for device in active_devices:
    print("IP:", device["ip"], "MAC:", device["mac"])
