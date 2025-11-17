# AUDITORÍA COMPLETA CON DETECCIÓN DE TESTS Y DUMMIES
param(
    [string]$ProjectPath = ".",
    [switch]$GenerateReport,
    [switch]$FindTests,
    [switch]$FindDummies
)

# CONFIGURACIÓN DE LOGGING
$LogPath = "D:\papeleracatalogo"
$LogFile = Join-Path $LogPath "auditoria_avanzada_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

# Función para logging
function Write-Log {
    param([string]$Message, [string]$Color = "White")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Write-Host $Message -ForegroundColor $Color
    Add-Content -Path $LogFile -Value $logMessage
}

# Patrones para identificar diferentes tipos de archivos
$testPatterns = @{
    "Test Files" = @("*.test.js", "*.test.ts", "*.test.jsx", "*.test.tsx", "*.spec.js", "*.spec.ts", "*.spec.jsx", "*.spec.tsx")
    "Test Directories" = @("**/test/**", "**/tests/**", "**/__tests__/**", "**/__test__/**")
    "Testing Config" = @("jest.config.*", "vitest.config.*", "cypress.json", "cypress.config.*", "karma.conf.*")
}

$dummyPatterns = @{
    "Mock Files" = @("**/mock/**", "**/mocks/**", "**/__mocks__/**", "**/*.mock.*", "**/*.mock.*")
    "Fixture Files" = @("**/fixture/**", "**/fixtures/**", "**/__fixtures__/**", "**/*.fixture.*")
    "Sample Data" = @("**/sample/**", "**/samples/**", "**/data/**", "**/fake*", "**/dummy*", "**/stub*")
    "Demo Files" = @("**/demo/**", "**/demos/**", "**/example*", "**/examples/**")
}

Write-Log "=== AUDITORÍA AVANZADA - TESTS Y DUMMIES ===" -ForegroundColor Green
Write-Log "Iniciada: $(Get-Date)" -ForegroundColor Gray
Write-Log ""

# 1. DETECCIÓN DE ARCHIVOS DE TEST
if ($FindTests -or $true) {
    Write-Log "1. 🧪 DETECCIÓN DE ARCHIVOS DE TEST:" -ForegroundColor Yellow
    
    $foundTests = @()
    
    foreach ($testType in $testPatterns.GetEnumerator()) {
        Write-Log "   🔍 Buscando: $($testType.Key)" -ForegroundColor Cyan
        
        foreach ($pattern in $testType.Value) {
            try {
                $testFiles = Get-ChildItem -Path $ProjectPath -Recurse -Include $pattern -ErrorAction SilentlyContinue
                foreach ($file in $testFiles) {
                    $foundTests += [PSCustomObject]@{
                        Tipo = $testType.Key
                        Archivo = $file.Name
                        Ruta = $file.FullName
                        Tamaño = "$([math]::Round($file.Length/1KB, 2)) KB"
                    }
                    Write-Log "     ✅ $($file.Name) - $([math]::Round($file.Length/1KB, 2)) KB" -ForegroundColor Green
                }
            }
            catch {
                Write-Log "     ❌ Error buscando patrón: $pattern" -ForegroundColor Red
            }
        }
    }
    
    if ($foundTests.Count -gt 0) {
        Write-Log "   📊 RESUMEN TESTS: $($foundTests.Count) archivos encontrados" -ForegroundColor Green
        
        # Agrupar por tipo
        $groupedTests = $foundTests | Group-Object Tipo
        foreach ($group in $groupedTests) {
            Write-Log "     $($group.Name): $($group.Count) archivos" -ForegroundColor Gray
        }
    } else {
        Write-Log "   ℹ️  No se encontraron archivos de test" -ForegroundColor Yellow
    }
}

# 2. DETECCIÓN DE ARCHIVOS DUMMY/MOCKS
if ($FindDummies -or $true) {
    Write-Log "`n2. 🎭 DETECCIÓN DE ARCHIVOS DUMMY/MOCKS:" -ForegroundColor Yellow
    
    $foundDummies = @()
    
    foreach ($dummyType in $dummyPatterns.GetEnumerator()) {
        Write-Log "   🔍 Buscando: $($dummyType.Key)" -ForegroundColor Cyan
        
        foreach ($pattern in $dummyType.Value) {
            try {
                $dummyFiles = Get-ChildItem -Path $ProjectPath -Recurse -Include $pattern -ErrorAction SilentlyContinue
                foreach ($file in $dummyFiles) {
                    $foundDummies += [PSCustomObject]@{
                        Tipo = $dummyType.Key
                        Archivo = $file.Name
                        Ruta = $file.FullName
                        Tamaño = "$([math]::Round($file.Length/1KB, 2)) KB"
                    }
                    Write-Log "     🎯 $($file.Name) - $([math]::Round($file.Length/1KB, 2)) KB" -ForegroundColor Magenta
                }
            }
            catch {
                Write-Log "     ❌ Error buscando patrón: $pattern" -ForegroundColor Red
            }
        }
    }
    
    if ($foundDummies.Count -gt 0) {
        Write-Log "   📊 RESUMEN DUMMIES: $($foundDummies.Count) archivos encontrados" -ForegroundColor Magenta
        
        # Agrupar por tipo
        $groupedDummies = $foundDummies | Group-Object Tipo
        foreach ($group in $groupedDummies) {
            Write-Log "     $($group.Name): $($group.Count) archivos" -ForegroundColor Gray
        }
    } else {
        Write-Log "   ℹ️  No se encontraron archivos dummy/mocks" -ForegroundColor Yellow
    }
}

# 3. ANÁLISIS DE DEPENDENCIAS DE TESTING
Write-Log "`n3. 📦 DEPENDENCIAS DE TESTING:" -ForegroundColor Yellow
$packageJson = Join-Path $ProjectPath "package.json"
if (Test-Path $packageJson) {
    try {
        $pkg = Get-Content $packageJson -Raw | ConvertFrom-Json
        Write-Log "   ✅ package.json cargado" -ForegroundColor Green
        
        # Dependencias de testing comunes
        $testingDeps = @{
            "jest" = "Framework de testing"
            "vitest" = "Testing con Vite"
            "cypress" = "Testing E2E"
            "@testing-library/react" = "Testing React"
            "@testing-library/jest-dom" = "Jest DOM"
            "mocha" = "Framework testing"
            "chai" = "Assertions"
            "sinon" = "Mocks y stubs"
            "@types/jest" = "Tipos para Jest"
        }
        
        $foundTestingDeps = 0
        foreach ($dep in $testingDeps.GetEnumerator()) {
            $version = $pkg.dependencies.($dep.Key) ?? $pkg.devDependencies.($dep.Key)
            if ($version) {
                Write-Log "   ✅ $($dep.Key) - $version - $($dep.Value)" -ForegroundColor Green
                $foundTestingDeps++
            } else {
                Write-Log "   ❌ $($dep.Key) - FALTANTE - $($dep.Value)" -ForegroundColor Red
            }
        }
        
        Write-Log "   📊 Dependencias de testing encontradas: $foundTestingDeps/$($testingDeps.Count)" -ForegroundColor Cyan
        
        # Scripts de testing
        if ($pkg.scripts) {
            Write-Log "   🚀 SCRIPTS DE TESTING:" -ForegroundColor Cyan
            $testScripts = $pkg.scripts.PSObject.Properties | Where-Object { 
                $_.Name -match "test|spec|cypress|jest|vitest" 
            }
            
            if ($testScripts) {
                foreach ($script in $testScripts) {
                    Write-Log "     ▶️  $($script.Name): $($script.Value)" -ForegroundColor Gray
                }
            } else {
                Write-Log "     ℹ️  No se encontraron scripts de testing" -ForegroundColor Yellow
            }
        }
    }
    catch {
        Write-Log "   ❌ Error leyendo package.json" -ForegroundColor Red
    }
}

# 4. CONFIGURACIONES DE TESTING
Write-Log "`n4. ⚙️ CONFIGURACIONES DE TESTING:" -ForegroundColor Yellow
$testingConfigs = @(
    "jest.config.js", "jest.config.ts", "jest.config.json",
    "vitest.config.js", "vitest.config.ts", 
    "cypress.json", "cypress.config.js", "cypress.config.ts",
    "karma.conf.js", "karma.conf.ts",
    ".test.env", ".test.env.local", ".env.test"
)

$foundConfigs = 0
foreach ($config in $testingConfigs) {
    if (Test-Path (Join-Path $ProjectPath $config)) {
        Write-Log "   ✅ $config" -ForegroundColor Green
        $foundConfigs++
    }
}

if ($foundConfigs -eq 0) {
    Write-Log "   ℹ️  No se encontraron configuraciones de testing específicas" -ForegroundColor Yellow
}

# 5. ANÁLISIS DE COBERTURA DE TEST
Write-Log "`n5. 📈 ANÁLISIS DE COBERTURA:" -ForegroundColor Yellow
$coverageDirs = @("coverage", "**/coverage/**", "**/__coverage__/**")
$coverageFiles = @("coverage/lcov.info", "coverage/coverage-final.json")

foreach ($dir in $coverageDirs) {
    if (Test-Path (Join-Path $ProjectPath $dir)) {
        Write-Log "   📊 Directorio de cobertura encontrado: $dir" -ForegroundColor Green
    }
}

foreach ($file in $coverageFiles) {
    if (Test-Path (Join-Path $ProjectPath $file)) {
        Write-Log "   📄 Archivo de cobertura encontrado: $file" -ForegroundColor Green
    }
}

# RESUMEN FINAL
Write-Log "`n=== RESUMEN FINAL TESTS/DUMMIES ===" -ForegroundColor Green

if ($foundTests) {
    Write-Log "🧪 ARCHIVOS DE TEST: $($foundTests.Count)" -ForegroundColor Green
    $foundTests | Group-Object Tipo | ForEach-Object {
        Write-Log "   $($_.Name): $($_.Count) archivos" -ForegroundColor Gray
    }
}

if ($foundDummies) {
    Write-Log "🎭 ARCHIVOS DUMMY: $($foundDummies.Count)" -ForegroundColor Magenta
    $foundDummies | Group-Object Tipo | ForEach-Object {
        Write-Log "   $($_.Name): $($_.Count) archivos" -ForegroundColor Gray
    }
}

Write-Log "`n=== AUDITORÍA COMPLETADA ===" -ForegroundColor Green
Write-Log "Log guardado en: $LogFile" -ForegroundColor Gray

# GENERAR REPORTE DETALLADO
if ($GenerateReport) {
    $reporte = Join-Path $LogPath "reporte_tests_dummies_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    
    $contenido = @"
INFORME DE TESTS Y DUMMIES
==========================
Fecha: $(Get-Date)
Proyecto: $(Resolve-Path $ProjectPath)

RESUMEN TESTS:
$(if ($foundTests) { 
    "Total archivos de test: $($foundTests.Count)`n"
    $foundTests | Group-Object Tipo | ForEach-Object { "  $($_.Name): $($_.Count)`n" }
} else { "No se encontraron archivos de test`n" })

RESUMEN DUMMIES:
$(if ($foundDummies) { 
    "Total archivos dummy: $($foundDummies.Count)`n"
    $foundDummies | Group-Object Tipo | ForEach-Object { "  $($_.Name): $($_.Count)`n" }
} else { "No se encontraron archivos dummy`n" })

DETALLES COMPLETOS EN: $LogFile
"@
    
    $contenido | Out-File $reporte -Encoding UTF8
    Write-Log "📄 Reporte específico generado: $reporte" -ForegroundColor Cyan
}