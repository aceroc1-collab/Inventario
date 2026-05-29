-- ─────────────────────────────────────────────────────────────────
-- PEPTILAB — Setup de base de datos en Supabase
-- Ejecuta este script completo en el SQL Editor de tu proyecto
-- ─────────────────────────────────────────────────────────────────

-- 1. TABLA DE INVENTARIO
-- Guarda el stock actual de cada producto
CREATE TABLE IF NOT EXISTS inventory (
  product_id  TEXT PRIMARY KEY,
  stock       INTEGER NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 2. TABLA DE OPERACIONES (historial)
-- Guarda cada venta, compra, devolución o pérdida registrada
CREATE TABLE IF NOT EXISTS operations (
  id          BIGINT PRIMARY KEY,
  type        TEXT NOT NULL CHECK (type IN ('venta','compra','devolucion','perdida')),
  operator    TEXT,
  items       JSONB NOT NULL,
  total       NUMERIC(10,2) DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ÍNDICES para consultas rápidas
CREATE INDEX IF NOT EXISTS idx_operations_created_at ON operations(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_operations_type       ON operations(type);
CREATE INDEX IF NOT EXISTS idx_operations_operator   ON operations(operator);

-- 4. HABILITAR REALTIME en ambas tablas
-- (para que todos los dispositivos se sincronicen automáticamente)
ALTER TABLE inventory  REPLICA IDENTITY FULL;
ALTER TABLE operations REPLICA IDENTITY FULL;

-- 5. ROW LEVEL SECURITY — acceso libre (sin login de usuarios)
-- Si en el futuro quieres autenticación, aquí se agregan las políticas
ALTER TABLE inventory  ENABLE ROW LEVEL SECURITY;
ALTER TABLE operations ENABLE ROW LEVEL SECURITY;

-- Permitir lectura y escritura con la API key pública (anon)
CREATE POLICY "Allow public read inventory"
  ON inventory FOR SELECT USING (true);

CREATE POLICY "Allow public write inventory"
  ON inventory FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow public read operations"
  ON operations FOR SELECT USING (true);

CREATE POLICY "Allow public write operations"
  ON operations FOR ALL USING (true) WITH CHECK (true);

-- 6. INICIALIZAR INVENTARIO con todos los productos en 0
-- (solo si la tabla está vacía)
INSERT INTO inventory (product_id, stock) VALUES
  ('tirz10', 0),
  ('tirz20', 0),
  ('reta10', 0),
  ('reta20', 0),
  ('bpc5',   0),
  ('bpc10',  0),
  ('tb5',    0),
  ('tb10',   0),
  ('nad',    0),
  ('ghk',    0),
  ('tesa',   0),
  ('klow',   0)
ON CONFLICT (product_id) DO NOTHING;

-- ─────────────────────────────────────────────────────────────────
-- Listo! Ahora ve a la app → Ajustes y pega la URL y API Key
-- ─────────────────────────────────────────────────────────────────
