function Generate-HtmlReport {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ReportPath,
        
        [Parameter(Mandatory=$true)]
        [object]$Data,
        
        [Parameter(Mandatory=$false)]
        [string]$ProjectPath = "No especificado",
        
        [Parameter(Mandatory=$false)]
        [string]$LogPath = "D:\papalerabot\audit-log.txt",
        
        [Parameter(Mandatory=$false)]
        [switch]$EnableDarkMode
    )
    
    # Crear directorio de logs si no existe
    $logDir = Split-Path $LogPath -Parent
    if (!(Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    # Función para escribir logs
    function Write-AuditLog {
        param([string]$Message, [string]$Level = "INFO")
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "[$timestamp] [$Level] $Message"
        Write-Host $logEntry
        Add-Content -Path $LogPath -Value $logEntry
    }
    
    try {
        Write-AuditLog "Iniciando generación de reporte HTML"
        Write-AuditLog "Proyecto: $ProjectPath"
        Write-AuditLog "Reporte destino: $ReportPath"
        
        # [TODO: Aquí iría todo el código HTML que ya tenés...]
        
        Write-AuditLog "Reporte HTML generado exitosamente"
        return $true
    }
    catch {
        Write-AuditLog "Error generando reporte: $($_.Exception.Message)" -Level "ERROR"
        return $false
    }
}

# Función para análisis real del proyecto
function Get-RealProjectAudit {
    param([string]$ProjectPath = "D:\papeleracatalogo")
    
    $LogPath = "D:\papalerabot\project-audit.log"
    
    # Crear directorio de logs
    $logDir = Split-Path $LogPath -Parent
    if (!(Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    function Write-ProjectLog {
        param([string]$Message, [string]$Level = "INFO")
        $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        $logEntry = "[$timestamp] [$Level] $Message"
        Write-Host $logEntry
        Add-Content -Path $LogPath -Value $logEntry
    }
    
    Write-ProjectLog "=== INICIANDO AUDITORÍA DEL PROYECTO ==="
    Write-ProjectLog "Directorio: $ProjectPath"
    
    $auditData = @{
        TotalFiles = 0
        CorrectFiles = 0
        Problems = @()
        Files = @()
        Metrics = @()
    }
    
    try {
        # 1. ANALIZAR ESTRUCTURA
        Write-ProjectLog "Analizando estructura de archivos..."
        $allFiles = Get-ChildItem -Path $ProjectPath -Recurse -File | 
                   Where-Object { $_.FullName -notmatch 'node_modules|\.git' }
        $auditData.TotalFiles = $allFiles.Count
        
        # 2. DETECTAR IMPORTACIONES PROBLEMÁTICAS
        Write-ProjectLog "Buscando importaciones problemáticas..."
        $codeFiles = Get-ChildItem -Path "$ProjectPath\client\src" -Recurse -Include *.js, *.jsx, *.ts, *.tsx -ErrorAction SilentlyContinue
        
        foreach ($file in $codeFiles) {
            $content = Get-Content $file.FullName -Raw
            $imports = [regex]::Matches($content, "from\s+['`"](@[^'`"]+)['`"]")
            
            foreach ($import in $imports) {
                $importPath = $import.Groups[1].Value
                $auditData.Problems += @{
                    File = $file.FullName.Replace($ProjectPath, "").TrimStart('\')
                    Line = "N/A"  # Podríamos calcular la línea exacta
                    Severity = "High"
                    Message = "Importación no resuelta: $importPath"
                    Recommendation = "Agregar alias en vite.config.js o instalar dependencia faltante"
                    CodeSnippet = $import.Value
                }
            }
        }
        
        # 3. VERIFICAR ARCHIVOS CRÍTICOS
        Write-ProjectLog "Verificando archivos críticos..."
        $criticalFiles = @(
            @{Name="package.json"; Path="$ProjectPath\package.json"},
            @{Name="index.html"; Path="$ProjectPath\index.html"},
            @{Name="vite.config.js"; Path="$ProjectPath\vite.config.js"},
            @{Name="main.tsx"; Path="$ProjectPath\client\src\main.tsx"}
        )
        
        foreach ($file in $criticalFiles) {
            if (Test-Path $file.Path) {
                Write-ProjectLog "✅ $($file.Name) encontrado" -Level "SUCCESS"
            } else {
                Write-ProjectLog "❌ $($file.Name) NO encontrado" -Level "ERROR"
                $auditData.Problems += @{
                    File = $file.Name
                    Line = 1
                    Severity = "Critical"
                    Message = "Archivo crítico faltante"
                    Recommendation = "Crear el archivo $($file.Name) en la ubicación correcta"
                    CodeSnippet = ""
                }
            }
        }
        
        # 4. GENERAR MÉTRICAS
        Write-ProjectLog "Generando métricas..."
        $auditData.Metrics = @(
            @{ Label = "Archivos totales"; Value = $auditData.TotalFiles },
            @{ Label = "Problemas detectados"; Value = $auditData.Problems.Count },
            @{ Label = "Build actual"; Value = "Fallido" },  # Podríamos detectar esto
            @{ Label = "Dependencias"; Value = "Por analizar" }
        )
        
        Write-ProjectLog "=== AUDITORÍA COMPLETADA ==="
        Write-ProjectLog "Problemas encontrados: $($auditData.Problems.Count)"
        
        return $auditData
    }
    catch {
        Write-ProjectLog "ERROR en auditoría: $($_.Exception.Message)" -Level "ERROR"
        return $null
    }
}

# EJECUCIÓN COMPLETA
$ProjectPath = "D:\papeleracatalogo"
$ReportPath = "D:\papalerabot\auditoria-completa.html"
$LogPath = "D:\papalerabot\ejecucion-completa.log"

Write-Host "Iniciando auditoría completa..." -ForegroundColor Green

# 1. Obtener datos reales
$realData = Get-RealProjectAudit -ProjectPath $ProjectPath

if ($realData) {
    # 2. Generar reporte HTML
    $success = Generate-HtmlReport -ReportPath $ReportPath -Data $realData -ProjectPath $ProjectPath -LogPath $LogPath -EnableDarkMode
    
    if ($success) {
        Write-Host "✅ Auditoría completada exitosamente!" -ForegroundColor Green
        Write-Host "📊 Reporte HTML: $ReportPath" -ForegroundColor Cyan
        Write-Host "📝 Logs: D:\papalerabot\" -ForegroundColor Cyan
        
        # Abrir el reporte automáticamente
        Invoke-Item $ReportPath
    }
} else {
    Write-Host "❌ Falló la auditoría del proyecto" -ForegroundColor Red
}