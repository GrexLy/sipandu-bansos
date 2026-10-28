-- ============================================================================
-- SIPANDU — Sistem Informasi Pelacakan dan Transparansi Bantuan Sosial
-- Kelompok 2 - STRES | SIF302 Pengembangan Aplikasi Berbasis Web (2026/2027)
-- Skema Database SQL (Mendukung Multi-Tenant Berjenjang DIY & Prototipe Kelurahan)
-- ============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------------------------------------------------------
-- 1. Tabel Wilayah Berjenjang (Multi-Tenant: Provinsi -> Kab/Kota -> Kapanewon -> Kalurahan -> RW)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `wilayah`;
CREATE TABLE `wilayah` (
    `id_wilayah` INT AUTO_INCREMENT PRIMARY KEY,
    `kode_wilayah` VARCHAR(20) NOT NULL UNIQUE,
    `nama_wilayah` VARCHAR(100) NOT NULL,
    `tingkat` ENUM('PROVINSI', 'KABUPATEN_KOTA', 'KAPANEWON_KEMANTREN', 'KALURAHAN_KELURAHAN', 'RW') NOT NULL,
    `parent_id` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_wilayah_parent` FOREIGN KEY (`parent_id`) REFERENCES `wilayah`(`id_wilayah`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 2. Tabel Pengguna & Hak Akses Berjenjang (Role-Based Access Control / RBAC)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `pengguna`;
CREATE TABLE `pengguna` (
    `id_pengguna` INT AUTO_INCREMENT PRIMARY KEY,
    `nama_lengkap` VARCHAR(100) NOT NULL,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `password_hash` VARCHAR(255) NOT NULL,
    `peran` ENUM('ADMIN_PROVINSI', 'OPERATOR_KABKOTA', 'ADMIN_KALURAHAN', 'PETUGAS_VERIFIKATOR', 'PETUGAS_PENYALUR') NOT NULL,
    `id_wilayah` INT NOT NULL,
    `status_aktif` TINYINT(1) NOT NULL DEFAULT 1,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_pengguna_wilayah` FOREIGN KEY (`id_wilayah`) REFERENCES `wilayah`(`id_wilayah`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 3. Tabel Basis Data Kependudukan Dummy (Simulasi Referensi / Mock API Dukcapil & DTSEN)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `kependudukan_dummy`;
CREATE TABLE `kependudukan_dummy` (
    `id_penduduk` INT AUTO_INCREMENT PRIMARY KEY,
    `nik` CHAR(16) NOT NULL UNIQUE,
    `no_kk` CHAR(16) NOT NULL,
    `nama_lengkap` VARCHAR(100) NOT NULL,
    `alamat` VARCHAR(255) NOT NULL,
    `id_wilayah_rw` INT NOT NULL,
    `pekerjaan` VARCHAR(80) DEFAULT NULL,
    `penghasilan_bulanan` DECIMAL(12,2) DEFAULT 0.00,
    `desil_kesejahteraan` TINYINT DEFAULT NULL COMMENT '1-4: Layak Bansos, 5-10: Mampu',
    `status_kependudukan` ENUM('AKTIF', 'PINDAH', 'MENINGGAL', 'DATA_TIDAK_LENGKAP') NOT NULL DEFAULT 'AKTIF',
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_penduduk_wilayah` FOREIGN KEY (`id_wilayah_rw`) REFERENCES `wilayah`(`id_wilayah`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 4. Tabel Program Bantuan Sosial (Fitur Wajib #2)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `program_bantuan`;
CREATE TABLE `program_bantuan` (
    `id_program` INT AUTO_INCREMENT PRIMARY KEY,
    `kode_program` VARCHAR(30) NOT NULL UNIQUE,
    `nama_program` VARCHAR(120) NOT NULL,
    `jenis_bantuan` ENUM('TUNAI', 'SEMBAKO_PANGAN', 'SUBSIDI_KHUSUS') NOT NULL,
    `periode_penyaluran` VARCHAR(50) NOT NULL COMMENT 'Contoh: Tahap IV - Oktober s.d. Desember 2026',
    `nilai_bantuan` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    `keterangan_kriteria` TEXT DEFAULT NULL,
    `status_program` ENUM('PERSIAPAN', 'BERJALAN', 'SELESAI') NOT NULL DEFAULT 'BERJALAN',
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 5. Tabel Titik Pencairan Bantuan (Fitur Wajib #2)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `titik_pencairan`;
CREATE TABLE `titik_pencairan` (
    `id_titik` INT AUTO_INCREMENT PRIMARY KEY,
    `id_wilayah` INT NOT NULL,
    `nama_titik` VARCHAR(120) NOT NULL COMMENT 'Contoh: Balai Kalurahan Sumberharjo / Pos Penyaluran RW 01',
    `alamat_lokasi` VARCHAR(255) NOT NULL,
    `jadwal_mulai` DATETIME NOT NULL,
    `jadwal_selesai` DATETIME NOT NULL,
    `penanggung_jawab` VARCHAR(100) NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_titik_wilayah` FOREIGN KEY (`id_wilayah`) REFERENCES `wilayah`(`id_wilayah`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 6. Tabel Calon & Penerima Bantuan / KPM + Verifikasi (Fitur Wajib #1 / US-01)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `penerima_bantuan`;
CREATE TABLE `penerima_bantuan` (
    `id_penerima` INT AUTO_INCREMENT PRIMARY KEY,
    `nik_input` CHAR(16) NOT NULL,
    `no_kk_input` CHAR(16) NOT NULL,
    `nama_penerima` VARCHAR(100) NOT NULL,
    `alamat_penerima` VARCHAR(255) NOT NULL,
    `id_wilayah_rw` INT NOT NULL,
    `id_program` INT NOT NULL,
    `id_titik_pencairan` INT DEFAULT NULL,
    `status_verifikasi` ENUM('MENUNGGU_VERIFIKASI', 'TERVERIFIKASI_LAYAK', 'DITOLAK_DUPLIKAT', 'DITOLAK_TIDAK_SESUAI_KRITERIA', 'DATA_TIDAK_LENGKAP') NOT NULL DEFAULT 'MENUNGGU_VERIFIKASI',
    `catatan_verifikasi` TEXT DEFAULT NULL,
    `verified_by` INT DEFAULT NULL,
    `verified_at` DATETIME DEFAULT NULL,
    `status_penyaluran_terkini` ENUM('BELUM_DIJADWALKAN', 'TERJADWAL_DI_TITIK_PENCAIRAN', 'SIAP_DISALURKAN', 'SEDANG_DISALURKAN', 'TELAH_DITERIMA_WARGA', 'TERKENDALA') NOT NULL DEFAULT 'BELUM_DIJADWALKAN',
    `waktu_diterima_warga` DATETIME DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_penerima_wilayah` FOREIGN KEY (`id_wilayah_rw`) REFERENCES `wilayah`(`id_wilayah`),
    CONSTRAINT `fk_penerima_program` FOREIGN KEY (`id_program`) REFERENCES `program_bantuan`(`id_program`),
    CONSTRAINT `fk_penerima_titik` FOREIGN KEY (`id_titik_pencairan`) REFERENCES `titik_pencairan`(`id_titik`),
    CONSTRAINT `fk_penerima_verifikator` FOREIGN KEY (`verified_by`) REFERENCES `pengguna`(`id_pengguna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 7. Tabel Riwayat Pelacakan Distribusi Bantuan (Fitur Wajib #3 ★ Fitur Inti / US-02)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `riwayat_distribusi`;
CREATE TABLE `riwayat_distribusi` (
    `id_riwayat` INT AUTO_INCREMENT PRIMARY KEY,
    `id_penerima` INT NOT NULL,
    `id_titik_pencairan` INT DEFAULT NULL,
    `status_sebelumnya` VARCHAR(50) DEFAULT NULL,
    `status_baru` ENUM('BELUM_DIJADWALKAN', 'TERJADWAL_DI_TITIK_PENCAIRAN', 'SIAP_DISALURKAN', 'SEDANG_DISALURKAN', 'TELAH_DITERIMA_WARGA', 'TERKENDALA') NOT NULL,
    `keterangan_tahap` TEXT NOT NULL,
    `diperbarui_oleh` INT NOT NULL,
    `waktu_pembaruan` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_riwayat_penerima` FOREIGN KEY (`id_penerima`) REFERENCES `penerima_bantuan`(`id_penerima`) ON DELETE CASCADE,
    CONSTRAINT `fk_riwayat_titik` FOREIGN KEY (`id_titik_pencairan`) REFERENCES `titik_pencairan`(`id_titik`),
    CONSTRAINT `fk_riwayat_petugas` FOREIGN KEY (`diperbarui_oleh`) REFERENCES `pengguna`(`id_pengguna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 8. Tabel Pengaduan Online Masyarakat (Fitur Wajib #5 / US-03)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `pengaduan_online`;
CREATE TABLE `pengaduan_online` (
    `id_pengaduan` INT AUTO_INCREMENT PRIMARY KEY,
    `nomor_tiket` VARCHAR(30) NOT NULL UNIQUE,
    `id_penerima` INT DEFAULT NULL,
    `nik_pelapor` CHAR(16) NOT NULL,
    `nama_pelapor` VARCHAR(100) NOT NULL,
    `kontak_pelapor` VARCHAR(50) DEFAULT NULL,
    `id_wilayah` INT NOT NULL,
    `kategori_pengaduan` ENUM('BANTUAN_BELUM_DITERIMA', 'DATA_PENERIMA_TIDAK_SESUAI', 'NOMINAL_JENIS_TIDAK_SESUAI', 'KENDALA_TITIK_PENCAIRAN', 'LAINNYA') NOT NULL,
    `isi_laporan` TEXT NOT NULL,
    `status_pengaduan` ENUM('BARU_MASUK', 'DALAM_PEMERIKSAAN', 'DITINDAKLANJUTI', 'SELESAI') NOT NULL DEFAULT 'BARU_MASUK',
    `tanggapan_petugas` TEXT DEFAULT NULL,
    `ditangani_oleh` INT DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT `fk_pengaduan_penerima` FOREIGN KEY (`id_penerima`) REFERENCES `penerima_bantuan`(`id_penerima`) ON DELETE SET NULL,
    CONSTRAINT `fk_pengaduan_wilayah` FOREIGN KEY (`id_wilayah`) REFERENCES `wilayah`(`id_wilayah`),
    CONSTRAINT `fk_pengaduan_petugas` FOREIGN KEY (`ditangani_oleh`) REFERENCES `pengguna`(`id_pengguna`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------------------------------------------------------
-- 9. Tabel Audit Log Keamanan & Perubahan Status (Keamanan Data & RBAC)
-- ----------------------------------------------------------------------------
DROP TABLE IF EXISTS `audit_log`;
CREATE TABLE `audit_log` (
    `id_log` BIGINT AUTO_INCREMENT PRIMARY KEY,
    `id_pengguna` INT DEFAULT NULL,
    `aksi` VARCHAR(80) NOT NULL,
    `entitas` VARCHAR(50) NOT NULL,
    `id_entitas` INT DEFAULT NULL,
    `detail_perubahan` TEXT DEFAULT NULL,
    `ip_address` VARCHAR(45) DEFAULT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT `fk_audit_pengguna` FOREIGN KEY (`id_pengguna`) REFERENCES `pengguna`(`id_pengguna`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- SEED DATA DUMMY AWAL (Skenario Pengujian Kelurahan Sumberharjo - DIY)
-- Mencakup kasus: (1) Data Valid & Layak, (2) NIK Ganda/Duplikat, (3) Data Tidak Lengkap,
-- serta (4) Tidak Memenuhi Kriteria Desil Kesejahteraan.
-- ============================================================================

INSERT INTO `wilayah` (`id_wilayah`, `kode_wilayah`, `nama_wilayah`, `tingkat`, `parent_id`) VALUES
(1, '34', 'Daerah Istimewa Yogyakarta', 'PROVINSI', NULL),
(2, '34.04', 'Kabupaten Sleman', 'KABUPATEN_KOTA', 1),
(3, '34.04.09', 'Kapanewon Prambanan', 'KAPANEWON_KEMANTREN', 2),
(4, '34.04.09.2003', 'Kalurahan Sumberharjo', 'KALURAHAN_KELURAHAN', 3),
(5, '34.04.09.2003.RW01', 'RW 01 Sumberharjo', 'RW', 4),
(6, '34.04.09.2003.RW02', 'RW 02 Sumberharjo', 'RW', 4);

INSERT INTO `pengguna` (`id_pengguna`, `nama_lengkap`, `username`, `email`, `password_hash`, `peran`, `id_wilayah`) VALUES
(1, 'Admin Dinsos DIY', 'admin_dinsos', 'dinsos@jogjaprov.go.id', '$2y$10$DummyHashAdminDinsosDIY12345678901234567890123456', 'ADMIN_PROVINSI', 1),
(2, 'Petugas Verifikator Sumberharjo', 'verifikator_sumberharjo', 'verifikasi@sumberharjo.desa.id', '$2y$10$DummyHashVerifikatorSumberharjo1234567890123456', 'PETUGAS_VERIFIKATOR', 4),
(3, 'Petugas Penyalur Sumberharjo', 'penyalur_sumberharjo', 'distribusi@sumberharjo.desa.id', '$2y$10$DummyHashPenyalurSumberharjo1234567890123456789', 'PETUGAS_PENYALUR', 4);

INSERT INTO `kependudukan_dummy` (`id_penduduk`, `nik`, `no_kk`, `nama_lengkap`, `alamat`, `id_wilayah_rw`, `pekerjaan`, `penghasilan_bulanan`, `desil_kesejahteraan`, `status_kependudukan`) VALUES
(1, '3404090101800001', '3404090101100001', 'Siti Aminah', 'Dusun Krajan RT 01 / RW 01, Sumberharjo', 5, 'Buruh Harian Lepas', 850000.00, 1, 'AKTIF'),
(2, '3404090202750002', '3404090202100002', 'Budi Santoso', 'Dusun Gamparan RT 03 / RW 01, Sumberharjo', 5, 'Petani Penggarap', 1100000.00, 2, 'AKTIF'),
(3, '3404090303880003', '3404090303100003', 'Slamet Raharjo', 'Dusun Sengir RT 02 / RW 02, Sumberharjo', 6, 'Pedagang Kecil', 1200000.00, 3, 'DATA_TIDAK_LENGKAP'),
(4, '3404090404720004', '3404090404100004', 'Hendra Wijaya', 'Dusun Krajan RT 04 / RW 02, Sumberharjo', 6, 'Wiraswasta Menengah', 8500000.00, 8, 'AKTIF');

INSERT INTO `program_bantuan` (`id_program`, `kode_program`, `nama_program`, `jenis_bantuan`, `periode_penyaluran`, `nilai_bantuan`, `keterangan_kriteria`, `status_program`) VALUES
(1, 'BLT-PANGAN-2026-Q4', 'Bantuan Pangan & Sembako Kalurahan Tahap IV', 'SEMBAKO_PANGAN', 'Oktober - Desember 2026', 600000.00, 'Warga aktif dengan Desil Kesejahteraan 1 s.d. 4 dan tidak berstatus penerima ganda.', 'BERJALAN');

INSERT INTO `titik_pencairan` (`id_titik`, `id_wilayah`, `nama_titik`, `alamat_lokasi`, `jadwal_mulai`, `jadwal_selesai`, `penanggung_jawab`) VALUES
(1, 5, 'Pos Pencairan Balai RW 01 Sumberharjo', 'Balai Warga RW 01, Dusun Krajan, Sumberharjo', '2026-11-10 08:00:00', '2026-11-12 15:00:00', 'Ketua RW 01 & Petugas Penyalur Kalurahan'),
(2, 6, 'Pos Pencairan Balai Kalurahan Sumberharjo (RW 02)', 'Aula Kantor Kalurahan Sumberharjo', '2026-11-13 08:00:00', '2026-11-15 15:00:00', 'Kaur Kesejahteraan Sumberharjo');

INSERT INTO `penerima_bantuan` (`id_penerima`, `nik_input`, `no_kk_input`, `nama_penerima`, `alamat_penerima`, `id_wilayah_rw`, `id_program`, `id_titik_pencairan`, `status_verifikasi`, `catatan_verifikasi`, `verified_by`, `verified_at`, `status_penyaluran_terkini`, `waktu_diterima_warga`) VALUES
-- Skenario 1: Data Valid, Terverifikasi, dan Bantuan Telah Diterima Warga
(1, '3404090101800001', '3404090101100001', 'Siti Aminah', 'Dusun Krajan RT 01 / RW 01, Sumberharjo', 5, 1, 1, 'TERVERIFIKASI_LAYAK', 'Data sesuai referensi kependudukan (Desil 1, Aktif).', 2, '2026-10-25 10:15:00', 'TELAH_DITERIMA_WARGA', '2026-10-26 11:30:00'),
-- Skenario 2: Data Valid, Terverifikasi, Sedang Dijadwalkan di Titik Pencairan
(2, '3404090202750002', '3404090202100002', 'Budi Santoso', 'Dusun Gamparan RT 03 / RW 01, Sumberharjo', 5, 1, 1, 'TERVERIFIKASI_LAYAK', 'Data sesuai referensi kependudukan (Desil 2, Aktif).', 2, '2026-10-25 10:30:00', 'SIAP_DISALURKAN', NULL),
-- Skenario 3: Kasus Duplikasi NIK (NIK Siti Aminah diinput ulang pada pengajuan kedua)
(3, '3404090101800001', '3404090101100001', 'Siti Aminah (Pengajuan Ganda)', 'Dusun Krajan RT 01 / RW 01, Sumberharjo', 5, 1, NULL, 'DITOLAK_DUPLIKAT', 'Ditolak sistem: NIK 3404090101800001 sudah terdaftar aktif pada program BLT-PANGAN-2026-Q4.', 2, '2026-10-25 11:00:00', 'BELUM_DIJADWALKAN', NULL),
-- Skenario 4: Kasus Data Kependudukan Tidak Lengkap
(4, '3404090303880003', '3404090303100003', 'Slamet Raharjo', 'Dusun Sengir RT 02 / RW 02, Sumberharjo', 6, 1, NULL, 'DATA_TIDAK_LENGKAP', 'Status kependudukan pada mock API belum lengkap (dokumen KK perlu pembaruan).', 2, '2026-10-25 11:20:00', 'BELUM_DIJADWALKAN', NULL),
-- Skenario 5: Kasus Tidak Memenuhi Kriteria (Desil 8 / Mampu)
(5, '3404090404720004', '3404090404100004', 'Hendra Wijaya', 'Dusun Krajan RT 04 / RW 02, Sumberharjo', 6, 1, NULL, 'DITOLAK_TIDAK_SESUAI_KRITERIA', 'Ditolak: Masuk kategori Desil 8 (di luar kriteria penerima bantuan Desil 1-4).', 2, '2026-10-25 11:45:00', 'BELUM_DIJADWALKAN', NULL);

INSERT INTO `riwayat_distribusi` (`id_penerima`, `id_titik_pencairan`, `status_sebelumnya`, `status_baru`, `keterangan_tahap`, `diperbarui_oleh`, `waktu_pembaruan`) VALUES
(1, 1, 'BELUM_DIJADWALKAN', 'TERJADWAL_DI_TITIK_PENCAIRAN', 'Dijadwalkan pengambilan paket bantuan di Pos Balai RW 01.', 3, '2026-10-25 14:00:00'),
(1, 1, 'TERJADWAL_DI_TITIK_PENCAIRAN', 'SIAP_DISALURKAN', 'Paket bantuan telah tiba di titik pencairan Balai RW 01.', 3, '2026-10-26 08:30:00'),
(1, 1, 'SIAP_DISALURKAN', 'TELAH_DITERIMA_WARGA', 'Bantuan telah diserahkan dan dikonfirmasi diterima langsung oleh KPM (Siti Aminah).', 3, '2026-10-26 11:30:00'),
(2, 1, 'BELUM_DIJADWALKAN', 'TERJADWAL_DI_TITIK_PENCAIRAN', 'Dijadwalkan pengambilan paket bantuan di Pos Balai RW 01.', 3, '2026-10-25 14:10:00'),
(2, 1, 'TERJADWAL_DI_TITIK_PENCAIRAN', 'SIAP_DISALURKAN', 'Paket bantuan siap diambil oleh penerima di Pos Balai RW 01.', 3, '2026-10-26 08:35:00');

INSERT INTO `pengaduan_online` (`nomor_tiket`, `id_penerima`, `nik_pelapor`, `nama_pelapor`, `kontak_pelapor`, `id_wilayah`, `kategori_pengaduan`, `isi_laporan`, `status_pengaduan`, `tanggapan_petugas`, `ditangani_oleh`) VALUES
('ADU-20261026-001', 2, '3404090202750002', 'Budi Santoso', '081234567890', 5, 'KENDALA_TITIK_PENCAIRAN', 'Mohon informasi apakah pengambilan di Balai RW 01 dapat diwakilkan anggota satu KK karena saya sedang sakit?', 'DITINDAKLANJUTI', 'Dapat diwakilkan oleh anggota dalam satu Kartu Keluarga (KK) dengan membawa KTP asli dan KK asli.', 3),
('ADU-20261026-002', 4, '3404090303880003', 'Slamet Raharjo', '081298765432', 6, 'DATA_PENERIMA_TIDAK_SESUAI', 'Status verifikasi saya tertulis data tidak lengkap, berkas apa yang harus saya bawa ke kelurahan?', 'BARU_MASUK', NULL, NULL);

SET FOREIGN_KEY_CHECKS = 1;