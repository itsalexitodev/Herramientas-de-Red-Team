import os
import sys
import signal
import time
import tkinter as tk
from tkinter import messagebox
from tabulate import tabulate
from scapy.all import ARP, Ether, srp
from tkinter import ttk


class NetworkScannerGUI:
    def __init__(self):
        self.root = tk.Tk()
        self.root.title("Network Scanner")
        self.root.configure(background="black")

        self.label = tk.Label(
            self.root,
            text="Ingresa tu dirección de red en formato CIDR (ejemplo: xxx.xxx.xxx.xxx/xx):",
            foreground="green",
            background="black",
        )
        self.label.pack()

        self.entry = tk.Entry(self.root)
        self.entry.pack()

        self.scan_button = tk.Button(
            self.root,
            text="Escanear",
            command=self.start_scan,
            foreground="green",
            background="black",
        )
        self.scan_button.pack()

        self.exit_button = tk.Button(
            self.root,
            text="Salir",
            command=self.exit_script,
            foreground="green",
            background="black",
        )
        self.exit_button.pack()

        self.running = False
        self.active_devices = []
        self.progress_window = None
        self.table_window = None

        signal.signal(signal.SIGINT, self.signal_handler)

    def start_scan(self):
        if self.running:
            return

        self.running = True
        direccion_red = self.entry.get().strip()

        if not direccion_red:
            messagebox.showerror("Error", "Ingresa una dirección de red válida.")
            return

        if not self.check_admin():
            messagebox.showerror(
                "Error",
                "Este script requiere privilegios de administrador para su ejecución.",
            )
            self.exit_script()
            return

        self.active_devices = []
        self.show_progress_window()
        self.scan_network(direccion_red)

    def scan_network(self, ip):
        arp_request = ARP(pdst=ip)
        ether = Ether(dst="ff:ff:ff:ff:ff:ff")
        packet = ether / arp_request
        result = srp(packet, timeout=3, verbose=0)[0]

        total_packets = len(result)
        progress = 0

        for sent, received in result:
            progress += 1
            percentage = int((progress / total_packets) * 100)
            self.update_progress(percentage)

            mac = received.hwsrc
            device = {"IP": received.psrc, "MAC": mac}
            self.active_devices.append(device)

        self.hide_progress_window()
        self.show_table_window()

    def show_progress_window(self):
        self.progress_window = tk.Toplevel(self.root)
        self.progress_window.title("Escaneando Dispositivos")
        self.progress_window.configure(background="black")

        progress_label = tk.Label(
            self.progress_window,
            text="Escaneando dispositivos en la red...",
            foreground="green",
            background="black",
        )
        progress_label.pack(padx=10, pady=10)

        self.progress_bar = ttk.Progressbar(
            self.progress_window,
            orient=tk.HORIZONTAL,
            mode="determinate",
        )
        self.progress_bar.pack(padx=10, pady=10, fill=tk.X)

        self.progress_window.geometry(
            f"{progress_label.winfo_reqwidth()}x{progress_label.winfo_reqheight()}"
        )

    def hide_progress_window(self):
        if self.progress_window:
            self.progress_window.destroy()
            self.progress_window = None

    def update_progress(self, percentage):
        if self.progress_bar:
            self.progress_bar["value"] = percentage
            self.progress_window.update()

    def show_table_window(self):
        if not self.active_devices:
            messagebox.showinfo(
                "Información",
                "No se encontraron dispositivos activos en la red.",
            )
            return

        if self.table_window:
            self.table_window.destroy()
            self.table_window = None

        self.table_window = tk.Toplevel(self.root)
        self.table_window.title("Dispositivos en la Red")
        self.table_window.configure(background="black")

        table_headers = self.active_devices[0].keys()
        table_data = [list(device.values()) for device in self.active_devices]
        table = tabulate(table_data, headers=table_headers, tablefmt="fancy_grid")

        table_title = tk.Label(
            self.table_window,
            text="Dispositivos activos en la red:",
            foreground="green",
            background="black",
        )
        table_title.pack(padx=10, pady=10)

        table_label = tk.Label(
            self.table_window,
            text=table,
            foreground="green",
            background="black",
            justify=tk.LEFT,
            font=("Courier New", 12),
        )
        table_label.pack(padx=10, pady=10)

        width = int(table_label.winfo_reqwidth() * 1.25)
        height = int(table_label.winfo_reqheight() * 1.25)
        self.table_window.geometry(f"{width}x{height}")

        self.table_window.after(10000, self.show_table_window)  # Actualizar la tabla cada 10 segundos

    def exit_script(self):
        self.running = False
        self.root.destroy()

    def signal_handler(self, signal, frame):
        self.running = False
        self.exit_script()

    def check_admin(self):
        if os.name != "posix":
            return os.name == "nt" and os.getuid() == 0
        else:
            return os.getuid() == 0


if __name__ == "__main__":
    scanner = NetworkScannerGUI()
    scanner.root.mainloop()
