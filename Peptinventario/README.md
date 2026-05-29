# PeptiLab — Sistema de Inventario PWA

PWA para la gestión de inventario del equipo de ventas PeptiLab, con sincronización en tiempo real vía Supabase.

## Características

- **Operaciones**: Venta, Compra, Devolución, Pérdida
- **Operadores**: Wendy, David, Ricardo, Carlos
- **Inventario compartido en tiempo real** — todos ven el mismo stock
- **Historial** completo filtrable por tipo y operador
- **Control de precios**: precio modificable con motivo obligatorio
- **Modo offline**: funciona sin internet, sincroniza al reconectarse
- **Instalable** en iOS (Safari → Añadir a inicio) y Android

## Configurar Supabase (base de datos compartida)

### Paso 1 — Crear proyecto en Supabase
1. Ve a [supabase.com](https://supabase.com) y crea una cuenta gratis
2. Click en **New Project**, ponle nombre (ej: `peptilab`) y elige región
3. Guarda la contraseña del proyecto

### Paso 2 — Crear las tablas
1. En tu proyecto, ve a **SQL Editor**
2. Pega todo el contenido del archivo `supabase_setup.sql`
3. Click en **Run** — verás "Success"

### Paso 3 — Obtener credenciales
1. Ve a **Settings → API**
2. Copia la **Project URL** (ej: `https://abcxyz.supabase.co`)
3. Copia la **anon public** key

### Paso 4 — Conectar en la app
1. Abre la PWA → tab **Ajustes**
2. Pega la URL y la API Key
3. Click en **Guardar y Conectar**
4. Listo — todos los dispositivos verán el mismo inventario en tiempo real

## Deploy en Vercel

1. Sube esta carpeta a GitHub
2. Conecta el repo en [vercel.com](https://vercel.com) → Deploy
3. Comparte la URL con tu equipo

## Estructura

```
peptilab-pwa/
├── index.html           # App completa
├── manifest.json        # Config PWA
├── sw.js                # Service Worker (offline)
├── vercel.json          # Config Vercel
├── supabase_setup.sql   # Script SQL para crear las tablas
└── public/
    ├── logo.png
    ├── icon-192.png
    └── icon-512.png
```

## Agregar productos al catálogo

Edita el array `CATALOG` en `index.html`:
```js
{id:'nuevo_id', name:'Nombre Producto', dose:'X mg', price: 000},
```
Y agrega el ID en `supabase_setup.sql` dentro del INSERT inicial.
