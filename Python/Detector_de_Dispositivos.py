import os
import sys
import signal
import time
from tabulate import tabulate
from scapy.all import ARP, Ether, srp


class NetworkScanner:
    def __init__(self):
        self.running = False
        self.active_devices = []

    def start_scan(self, direccion_red):
        if self.running:
            return

        self.running = True
        self.active_devices = []

        if not direccion_red:
            print("Error: Ingresa una dirección de red válida.")
            return

        if not self.check_admin():
            print("Error: Este script requiere privilegios de administrador para su ejecución.")
            print("Por favor, ejecuta el script con privilegios de administrador.")
            return

        print("Escaneando dispositivos en la red...")

        try:
            while self.running:
                new_devices = self.scan_network(direccion_red)

                if new_devices:
                    if new_devices != self.active_devices:
                        self.active_devices = new_devices

                    table_headers = self.active_devices[0].keys()
                    table_data = [list(device.values()) for device in self.active_devices]
                    table = tabulate(table_data, headers=table_headers, tablefmt="fancy_grid")
                    os.system("clear" if os.name == "posix" else "cls")
                    print(table)
                else:
                    os.system("clear" if os.name == "posix" else "cls")
                    print("No se encontraron dispositivos activos en la red.")

                time.sleep(5)
        except KeyboardInterrupt:
            print("\nEscaneo detenido por el usuario.")

    def scan_network(self, ip):
        arp_request = ARP(pdst=ip)
        ether = Ether(dst="ff:ff:ff:ff:ff:ff")
        packet = ether/arp_request
        result = srp(packet, timeout=3, verbose=0)[0]

        active_devices = []
        for sent, received in result:
            mac = received.hwsrc
            device = {"IP": received.psrc, "MAC": mac}
            active_devices.append(device)

        return active_devices

    def check_admin(self):
        if os.name != "posix":
            return os.name == "nt" and os.getuid() == 0
        else:
            return os.getuid() == 0

    def signal_handler(self, signal, frame):
        self.running = False
        print("\nEscaneo detenido por el usuario.")
        sys.exit(0)


if __name__ == "__main__":
    scanner = NetworkScanner()
    scanner.start_scan(input("Ingresa tu dirección de red en formato CIDR (ejemplo: xxx.xxx.xxx.xxx/xx): "))
