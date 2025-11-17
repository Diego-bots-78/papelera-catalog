# Script para analizar proyecto PapeleraCatalog
# Ubicación: D:\papeleracatalogo\
# Ejecutar desde PowerShell: .\analizar-proyecto.ps1

Write-Host "🔍 ANALIZANDO PROYECTO PAPELERACATALOG..." -ForegroundColor Green
Write-Host "==============================================" -ForegroundColor Yellow

# Verificar si estamos en la carpeta correcta
$packageJson = Get-Content "package.json" -ErrorAction SilentlyContinue | ConvertFrom-Json

if (-not $packageJson) {
    Write-Host "❌ ERROR: No se encuentra package.json" -ForegroundColor Red
    Write-Host "💡 Asegúrate de ejecutar este script en la carpeta del proyecto" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Proyecto encontrado: $($packageJson.name)" -ForegroundColor Green
Write-Host "📍 Versión: $($packageJson.version)" -ForegroundColor Cyan

# Crear archivo de reporte
$reportFile = "reporte-proyecto.txt"
"REPORTE DEL PROYECTO PAPELERACATALOG" | Out-File $reportFile
"Generado: $(Get-Date)" | Out-File $reportFile -Append
"======================================" | Out-File $reportFile -Append

# 1. INFORMACIÓN BÁSICA
Write-Host "`n📊 1. INFORMACIÓN BÁSICA:" -ForegroundColor Green
"`nINFORMACIÓN BÁSICA:" | Out-File $reportFile -Append
"- Nombre: $($packageJson.name)" | Out-File $reportFile -Append
"- Versión: $($packageJson.version)" | Out-File $reportFile -Append
"- Tipo: $($packageJson.type)" | Out-File $reportFile -Append

# 2. SCRIPTS DISPONIBLES
Write-Host "`n🎯 2. SCRIPTS DISPONIBLES:" -ForegroundColor Green
"`nSCRIPTS DISPONIBLES (comandos que puedes usar):" | Out-File $reportFile -Append
foreach ($script in $packageJson.scripts.PSObject.Properties) {
    Write-Host "   pnpm $($script.Name): $($script.Value)" -ForegroundColor Cyan
    "   pnpm $($script.Name): $($script.Value)" | Out-File $reportFile -Append
}

# 3. TECNOLOGÍAS DETECTADAS
Write-Host "`n🛠️ 3. TECNOLOGÍAS PRINCIPALES:" -ForegroundColor Green
"`nTECNOLOGÍAS DETECTADAS:" | Out-File $reportFile -Append

$techs = @{
    "Frontend" = "React 19 + TypeScript + Vite"
    "Backend" = "Node.js + Express + tRPC"
    "Base de datos" = "MySQL + Drizzle ORM"
    "Estilos" = "Tailwind CSS"
    "Deploy" = "Build con esbuild"
}

foreach ($tech in $techs.GetEnumerator()) {
    Write-Host "   ✅ $($tech.Key): $($tech.Value)" -ForegroundColor White
    "   ✅ $($tech.Key): $($tech.Value)" | Out-File $reportFile -Append
}

# 4. ESTRUCTURA DE CARPETAS
Write-Host "`n📁 4. ESTRUCTURA DEL PROYECTO:" -ForegroundColor Green
"`nESTRUCTURA DE CARPETAS:" | Out-File $reportFile -Append

$folders = @("server/", "src/", "public/", "dist/")
foreach ($folder in $folders) {
    if (Test-Path $folder) {
        Write-Host "   📂 $folder (existe)" -ForegroundColor Green
        "   📂 $folder (existe)" | Out-File $reportFile -Append
    } else {
        Write-Host "   ❌ $folder (no existe)" -ForegroundColor Red
        "   ❌ $folder (no existe)" | Out-File $reportFile -Append
    }
}

# 5. GUÍA DE INICIO RÁPIDO
Write-Host "`n🚀 5. GUÍA DE INICIO RÁPIDO:" -ForegroundColor Green
$guiaInicio = @"

GUÍA DE INICIO RÁPIDO:
======================

1. INSTALAR DEPENDENCIAS:
   pnpm install

2. EJECUTAR EN MODO DESARROLLO:
   pnpm dev

3. CONSTRUIR PARA PRODUCCIÓN:
   pnpm build

4. EJECUTAR EN PRODUCCIÓN:
   pnpm start

5. VERIFICAR TIPOS TypeScript:
   pnpm check

ARCHIVOS IMPORTANTES:
- server/_core/index.ts (servidor principal)
- package.json (configuración del proyecto)
- Probablemente src/ para el frontend

CONFIGURACIÓN NECESARIA:
- Necesitas un archivo .env con variables de entorno
- Base de datos MySQL configurada

"@

Write-Host $guiaInicio -ForegroundColor Yellow
$guiaInicio | Out-File $reportFile -Append

# 6. PROBLEMAS DETECTADOS
Write-Host "`n⚠️ 6. PROBLEMAS DETECTADOS:" -ForegroundColor Red
"`nPROBLEMAS DETECTADOS:" | Out-File $reportFile -Append

$problemas = @(
    "Versiones antiguas de Express y dotenv (pueden tener vulnerabilidades)",
    "No hay linter (ESLint) para revisar código automáticamente",
    "Sistema de build usa dos herramientas diferentes (puede ser lento)",
    "No hay configuración visible de TypeScript (tsconfig.json)"
)

foreach ($problema in $problemas) {
    Write-Host "   ❗ $problema" -ForegroundColor Red
    "   ❗ $problema" | Out-File $reportFile -Append
}

# 7. RECOMENDACIONES
Write-Host "`n💡 7. RECOMENDACIONES INMEDIATAS:" -ForegroundColor Cyan
"`nRECOMENDACIONES INMEDIATAS:" | Out-File $reportFile -Append

$recomendaciones = @(
    "Ejecutar 'pnpm install' para instalar dependencias",
    "Buscar archivo .env.example o .env para configurar variables",
    "Verificar que tienes MySQL instalado y corriendo",
    "Comenzar con 'pnpm dev' para desarrollo"
)

foreach ($recomendacion in $recomendaciones) {
    Write-Host "   💡 $recomendacion" -ForegroundColor Cyan
    "   💡 $recomendacion" | Out-File $reportFile -Append
}

Write-Host "`n✅ ANÁLISIS COMPLETADO!" -ForegroundColor Green
Write-Host "📄 Reporte guardado en: $reportFile" -ForegroundColor Yellow
Write-Host "`n🎯 PRÓXIMOS PASOS:" -ForegroundColor Magenta
Write-Host "   1. Abre el archivo $reportFile para ver el reporte completo" -ForegroundColor White
Write-Host "   2. Ejecuta 'pnpm install' para instalar todo" -ForegroundColor White
Write-Host "   3. Ejecuta 'pnpm dev' para probar el proyecto" -ForegroundColor White