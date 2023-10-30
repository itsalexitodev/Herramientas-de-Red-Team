from setuptools import setup

setup(
    name="network-scanner-cli",
    version="1.0.0",
    description="CLI network scanner tool",
    author="Alex Garcia Rodriguez",
    author_email="itsalexitodev@gmail.com",
    url="https://github.com/itsalexitodev/Herramientas-de-Red-Team/blob/main/network_scanner.py",
    packages=["network_scanner_cli"],
    install_requires=[
        "scapy",
        "tabulate"
    ],
    entry_points={
        "console_scripts": [
            "network-scanner=network_scanner_cli:main"
        ]
    },
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
)
