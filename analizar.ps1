# Script corregido - analizar-proyecto
cd D:\papeleraCatalogo

Write-Host "🔍 ANALIZANDO PROYECTO..." -ForegroundColor Green

# Verificar package.json
if (Test-Path "package.json") {
    $package = Get-Content "package.json" | ConvertFrom-Json
    Write-Host "✅ Proyecto: $($package.name)" -ForegroundColor Green
    Write-Host "📍 Versión: $($package.version)" -ForegroundColor Cyan
    
    Write-Host "`n🎯 COMANDOS DISPONIBLES:" -ForegroundColor Green
    $package.scripts.PSObject.Properties | ForEach-Object {
        Write-Host "   pnpm $($_.Name): $($_.Value)" -ForegroundColor White
    }
} else {
    Write-Host "❌ No se encuentra package.json" -ForegroundColor Red
}

Write-Host "`n🚀 INICIAR PROYECTO:" -ForegroundColor Yellow
Write-Host "   1. pnpm install" -ForegroundColor White
Write-Host "   2. pnpm dev" -ForegroundColor White