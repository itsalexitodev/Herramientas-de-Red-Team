# Verificar si el script se está ejecutando como administrador
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host "Este script debe ejecutarse como administrador." -ForegroundColor Red
    pause
    exit
}

# Ejecutar 'winget upgrade'
Write-Host "Ejecutando 'winget upgrade'..." -ForegroundColor Green
winget upgrade

# Esperar a que finalice la actualización
Write-Host "Esperando a que finalice la actualización..." -ForegroundColor Green
Start-Sleep -Seconds 5

# Ejecutar 'winget upgrade --all'
Write-Host "Ejecutando 'winget upgrade --all'..." -ForegroundColor Green
winget upgrade --all

# Mostrar mensaje de finalización
Write-Host "¡Actualización completa!" -ForegroundColor Green
pause
