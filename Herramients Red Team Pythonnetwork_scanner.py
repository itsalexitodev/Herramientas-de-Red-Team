import os
import sys
import signal
import time
from tabulate import tabulate
from scapy.all import ARP, Ether, srp


class NetworkScannerCLI:
    def __init__(self):
        self.running = False
        self.active_devices = set()
        self.last_scan_devices = set()

        signal.signal(signal.SIGINT, self.signal_handler)

    def start_scan(self):
        if self.running:
            return

        self.running = True
        direccion_red = input("Ingresa tu dirección de red en formato CIDR (ejemplo: xxx.xxx.xxx.xxx/xx): ").strip()

        if not direccion_red:
            print("Error: Ingresa una dirección de red válida.")
            return

        if not self.check_admin():
            print("Error: Este script requiere privilegios de administrador para su ejecución.")
            self.exit_script()
            return

        try:
            while self.running:
                self.active_devices = set()
                self.scan_network(direccion_red)

                if self.active_devices != self.last_scan_devices:
                    self.last_scan_devices = self.active_devices
                    self.clear_screen()
                    self.show_devices()

                time.sleep(10)
        except KeyboardInterrupt:
            self.running = False
            print("\nEscaneo detenido por el usuario.")

    def scan_network(self, ip):
        arp_request = ARP(pdst=ip)
        ether = Ether(dst="ff:ff:ff:ff:ff:ff")
        packet = ether/arp_request
        result = srp(packet, timeout=3, verbose=0)[0]

        for sent, received in result:
            mac = received.hwsrc
            device = (received.psrc, mac)
            self.active_devices.add(device)

    def show_devices(self):
        if not self.active_devices:
            print("No se encontraron dispositivos activos en la red.")
            return

        table_headers = ["IP", "MAC"]
        table_data = list(self.active_devices)
        table = tabulate(table_data, headers=table_headers, tablefmt="fancy_grid")
        print("Dispositivos activos en la red:")
        print(table)

    def clear_screen(self):
        if os.name == "posix":
            os.system("clear")
        else:
            os.system("cls")

    def exit_script(self):
        self.running = False
        sys.exit(0)

    def signal_handler(self, signal, frame):
        self.running = False
        print("\nEscaneo detenido por el usuario.")
        sys.exit(0)

    def check_admin(self):
        if os.name != "posix":
            return os.name == "nt" and os.getuid() == 0
        else:
            return os.getuid() == 0


if __name__ == "__main__":
    scanner = NetworkScannerCLI()
    scanner.start_scan()
