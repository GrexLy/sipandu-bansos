<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIPANDU - Pengaduan Online</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="index.php">SIPANDU</a>
        </div>
    </nav>
    <div class="container py-5">
        <div class="card shadow-sm mx-auto" style="max-width: 650px;">
            <div class="card-header bg-white py-3">
                <h5 class="mb-0 fw-bold text-primary">Formulir Pengaduan Online Bantuan Sosial</h5>
            </div>
            <div class="card-body p-4">
                <form action="pengaduan.php" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Nomor Induk Kependudukan (NIK)</label>
                        <input type="text" name="nik" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nama Lengkap</label>
                        <input type="text" name="nama" class="form-control" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Kategori Kendala</label>
                        <select name="kategori" class="form-select" required>
                            <option value="BANTUAN_BELUM_DITERIMA">Bantuan Belum Diterima</option>
                            <option value="DATA_PENERIMA_TIDAK_SESUAI">Data Penerima Tidak Sesuai</option>
                            <option value="KENDALA_TITIK_PENCAIRAN">Kendala Lokasi / Jadwal Pencairan</option>
                            <option value="LAINNYA">Lainnya</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Isi Laporan Pengaduan</label>
                        <textarea name="laporan" class="form-control" rows="4" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Kirim Laporan Pengaduan</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
