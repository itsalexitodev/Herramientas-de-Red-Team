from setuptools import setup, find_packages

setup(
    name='mi_proyecto',
    version='1.0',
    description='Estas son las librerias para los programas network_scanner_gui y network_scanner',
    author='Alex Garcia Rodriguez',
    author_email='itsalexitodev@gmail.com',
    packages=find_packages(),
    install_requires=[
        'tabulate',
        'scapy',
        'tkinter',
    ],
)
