-- PEPTILAB — Setup Supabase (ejecutar en SQL Editor)

CREATE TABLE IF NOT EXISTS inventory (
  product_id  TEXT PRIMARY KEY,
  stock       INTEGER NOT NULL DEFAULT 0,
  updated_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS operations (
  id          BIGINT PRIMARY KEY,
  type        TEXT NOT NULL,
  operator    TEXT,
  items       JSONB NOT NULL,
  total       NUMERIC(10,2) DEFAULT 0,
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_ops_date ON operations(created_at DESC);

ALTER TABLE inventory  ENABLE ROW LEVEL SECURITY;
ALTER TABLE operations ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "public_inventory"  ON inventory;
DROP POLICY IF EXISTS "public_operations" ON operations;
DROP POLICY IF EXISTS "Allow public read inventory"  ON inventory;
DROP POLICY IF EXISTS "Allow public write inventory" ON inventory;
DROP POLICY IF EXISTS "Allow public read operations"  ON operations;
DROP POLICY IF EXISTS "Allow public write operations" ON operations;

CREATE POLICY "public_inventory"  ON inventory  FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "public_operations" ON operations FOR ALL USING (true) WITH CHECK (true);

ALTER TABLE inventory  REPLICA IDENTITY FULL;
ALTER TABLE operations REPLICA IDENTITY FULL;

-- Inventario inicial con stock real
INSERT INTO inventory (product_id, stock) VALUES
  ('klow',2),('tb10',18),('tirz20',30),('tirz10',30),
  ('nad',8),('tesa10',6),('selank',10),('semax',10),
  ('mots',9),('bpc10',54),('glow',10),('reta10',39),
  ('ipamorelin',10),('ghk100',7),('ghk50',8),('cjc',20),
  ('pt141',10),('reta20',20)
ON CONFLICT (product_id) DO UPDATE SET stock = EXCLUDED.stock;
