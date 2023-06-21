@echo off

REM Verificar si el script se está ejecutando como administrador
NET SESSION >nul 2>&1
IF %ERRORLEVEL% NEQ 0 (
    echo Este script debe ejecutarse como administrador.
    pause
    exit /b
)

REM Habilitar la característica de WSL en Windows
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

REM Habilitar la característica de Virtual Machine Platform
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

REM Descargar el instalador de Kali Linux
curl.exe -o kali.appx https://aka.ms/wsl-kali-linux-new

REM Instalar Kali Linux
Add-AppxPackage .\kali.appx

REM Mostrar mensaje de finalización
echo.
echo La distribución Kali Linux se ha instalado correctamente.
pause
