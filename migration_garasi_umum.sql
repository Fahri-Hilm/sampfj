-- ============================================================
-- Migrasi: Fitur Garasi Umum (Public Parking / GARKOT)
-- Jalankan SEKALI pada database hrp:
--   mysql -u root hrp < migration_garasi_umum.sql
-- ============================================================

-- 1) Tabel titik parkir umum
CREATE TABLE IF NOT EXISTS `parks` (
  `id`       int(11)    NOT NULL,
  `posx`     float      NOT NULL DEFAULT 0,
  `posy`     float      NOT NULL DEFAULT 0,
  `posz`     float      NOT NULL DEFAULT 0,
  `interior` int(11)    NOT NULL DEFAULT 0,
  `world`    int(11)    NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- 2) Kolom penanda kendaraan yang tersimpan di garasi umum.
--    -1 = tidak tersimpan di titik park mana pun (default untuk kendaraan lama).
ALTER TABLE `vehicle`
  ADD COLUMN IF NOT EXISTS `parkpoint` int(11) NOT NULL DEFAULT -1;
