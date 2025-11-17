# Catálogo de Precios - PAPELERA - TODO

## Fase 1: MVP - Estructura Base y Búsqueda Básica

- [x] Cargar datos de productos desde JSON (estructura Tidy Data)
- [x] Crear componente de búsqueda flexible (tolerante a errores)
- [x] Implementar vista de lista de productos con foto y precio
- [x] Crear vista detallada de producto con galería de fotos
- [x] Implementar tabla de precios por volumen
- [x] Agregar calculadora de pedido (cantidad → precio total)
- [x] Crear filtros dinámicos (Categoría, Tamaño, Unidad)
- [x] Diseñar interfaz móvil responsiva
- [x] Agregar botón de contacto (WhatsApp/Llamada)

## Fase 2: Mejoras y Optimización

- [ ] Implementar búsqueda semántica (Tags)
- [ ] Agregar sugerencias predictivas
- [ ] Optimizar carga de imágenes
- [ ] Implementar PWA (instalable en móvil)
- [ ] Agregar historial de búsquedas recientes
- [ ] Crear página de favoritos

## Fase 3: Integración Avanzada

- [ ] Integración con carrito de compras
- [ ] Sistema de notificaciones de cambios de precio
- [ ] Exportación de cotizaciones
- [ ] Integración con CRM/Sistema de ventas



## Fase 1.5: Extracción Completa de Datos y Búsqueda de Imágenes

- [x] Extraer todos los 636 filas del archivo Excel original (406 productos extraídos)
- [x] Identificar todas las secciones de productos (63 categorías)
- [x] Obtener precios de la columna G
- [x] Buscar imágenes reales para cada producto
- [x] Descargar y almacenar imágenes en el proyecto
- [x] Crear JSON completo con todos los items


## Fase 2: Rediseño de Estructura (Variantes Agrupadas)

- [x] Rediseñar JSON para agrupar variantes por producto base (376 productos base, 406 variantes)
- [x] Actualizar interfaz para mostrar una imagen por producto
- [x] Listar variantes (medidas, precios) debajo sin repetir imágenes
- [x] Eliminar búsqueda repetida de imágenes
- [x] Verificar que búsqueda funcione sin duplicados (búsqueda flexible probada)


## Fase 3: Corrección de Errores

- [x] Corregir error "Cannot read properties of undefined (reading '0')" en versión publicada
- [x] Verificar que el catálogo funcione correctamente en móvil
- [x] Validar que todas las imágenes se carguen sin errores


## Fase 4: Corrección de Carga de Datos

- [x] Investigar por qué products.json no se carga en versión publicada
- [x] Corregir la ruta o método de carga del archivo JSON (múltiples rutas)
- [x] Verificar que los productos se carguen correctamente en la versión publicada (376 productos cargados)


## Fase 5: Corrección de Imágenes (Coincidencia Correcta)

- [x] Buscar imágenes correctas en MercadoLibre Argentina para cada categoría (32 imágenes descargadas)
- [x] Descargar imágenes que coincidan exactamente con los productos
- [x] Reconstruir JSON con imágenes correctas asignadas a cada categoría (mapeo de 63 categorías)
- [x] Actualizar catálogo PWA con imágenes correctas (copiadas a public/images)
- [x] Verificar que las imágenes coincidan con los productos mostrados (bandejas, bolsas, vasos, etc.)


## URGENTE - Fase 6: Publicación Correcta de Imágenes

- [ ] Verificar que las imágenes estén en public/images y sean accesibles
- [ ] Asegurar que el JSON apunte a las rutas correctas de las imágenes
- [ ] Crear checkpoint y PUBLICAR para que los cambios se reflejen en vivo
- [ ] Verificar en la versión publicada que las imágenes correctas se muestren


## Fase 7: Mejoras de UX y Navegación

- [x] Mejorar botón "Volver al menú" con colores más llamativos
- [x] Hacer que scroll vaya al menú principal (header con título PAPELERA)
- [x] Implementar scroll automático suave cuando selecciona categoría
- [x] Agregar contador visual de cantidad en botón de carrito por producto


## Fase 8: Mejora de Experiencia del Carrito

- [x] Mostrar estado del carrito en header principal (vacío/cargado)
- [x] Agregar botón "Confirmar compra" en header para acceder al carrito
- [x] Crear botón flotante o accesible en vista de productos para ir al carrito
- [x] Mejorar visibilidad del carrito desde cualquier parte de la app


## Fase 9: Actualización de Categorías de Bolsas

- [x] Eliminar categoría "Bolsas Zipper" del catálogo
- [x] Crear categoría "Bolsas Ziploc" con productos y precios
- [x] Crear categoría "Bolsas Metalizadas" con productos y precios
- [x] Crear categoría "Bolsas Marrones/Madera" con productos y precios
- [x] Crear categoría "Doypack" con productos y precios
- [x] Descargar/procesar imágenes para las nuevas categorías


## Fase 10: Búsqueda y Descarga de Imágenes de Alta Calidad

- [x] Buscar imágenes para todas las categorías de productos
- [x] Descargar imágenes representativas (productos en uso/contexto)
- [x] Organizar imágenes en carpeta /public/images/
- [x] Actualizar JSON con rutas de imágenes correctas
- [x] Verificar que todas las imágenes se muestren correctamente


## Fase 11: Corrección de Imágenes de Productos

- [x] Buscar imágenes específicas y correctas para cada categoría
- [x] Reemplazar imágenes incorrectas en las categorías
- [x] Verificar que cada imagen coincida con su categoría
- [x] Guardar cambios y crear checkpoint

## Fase 12: Conversión a Full-Stack

- [x] Agregar características full-stack (servidor, base de datos, usuario)
- [ ] Resolver conflictos en Home.tsx (mantener catálogo existente)
- [ ] Configurar esquema de base de datos para productos y órdenes
- [ ] Implementar API endpoints para gestión de productos
- [ ] Integrar almacenamiento de archivos S3
- [ ] Migrar datos de productos JSON a base de datos
- [ ] Verificar y guardar cambios
