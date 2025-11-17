# AUDITORIA DE PROYECTO - PowerShell Script
param(
    [string]$ProjectPath = ".",
    [switch]$GenerateReport
)

# CONFIGURACIÓN DE LOGGING
$LogPath = "D:\papeleracatalogo"
$LogFile = Join-Path $LogPath "auditoria_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# Crear directorio de log si no existe
try {
    if (!(Test-Path $LogPath)) {
        New-Item -ItemType Directory -Path $LogPath -Force | Out-Null
        Write-Host "Directorio de log creado: $LogPath" -ForegroundColor Green
    }
}
catch {
    Write-Host "No se pudo crear el directorio de log: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

# Función para escribir en consola y log
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $Message -ForegroundColor $Color
    try {
        Add-Content -Path $LogFile -Value $logMessage -ErrorAction Stop
    }
    catch {
        Write-Host "Error escribiendo en log: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Log "=== INICIANDO AUDITORÍA ===" -Color Green

# 1. ESTRUCTURA DE CARPETAS
Write-Log "1. ESTRUCTURA DE CARPETAS:" -Color Yellow
Get-ChildItem -Path $ProjectPath -Recurse -Directory | Select-Object FullName

# 2. ARCHIVOS PRINCIPALES
Write-Log "2. ARCHIVOS PRINCIPALES:" -Color Yellow
$files = @("package.json", "vite.config.js", "index.html", "tsconfig.json")
foreach ($file in $files) {
    if (Test-Path (Join-Path $ProjectPath $file)) {
        Write-Log "   ✅ $file" -Color Green
    } else {
        Write-Log "   ❌ $file - FALTANTE" -Color Red
    }
}

Write-Log "=== AUDITORÍA COMPLETADA ===" -Color Green
Write-Log "Log guardado en: $LogFile" -Color Gray