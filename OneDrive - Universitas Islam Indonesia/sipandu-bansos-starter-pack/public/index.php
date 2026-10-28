<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SIPANDU - Portal Transparansi Bantuan Sosial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">SIPANDU</a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link active" href="index.php">Cek Status</a>
                <a class="nav-link" href="pengaduan.php">Pengaduan Online</a>
                <a class="nav-link btn btn-outline-light btn-sm ms-2 px-3" href="login.php">Login Petugas</a>
            </div>
        </div>
    </nav>
    <div class="container py-5 text-center">
        <h1 class="fw-bold text-primary mb-3">Portal Transparansi Bantuan Sosial</h1>
        <p class="text-muted">Lacak status pencairan bantuan sosial secara mandiri dan transparan.</p>
        <div class="card shadow-sm mx-auto mt-4" style="max-width: 600px;">
            <div class="card-body p-4">
                <form action="index.php" method="GET">
                    <div class="input-group mb-3">
                        <input type="text" name="nik" class="form-control" placeholder="Masukkan 16 Digit NIK Anda..." required>
                        <button class="btn btn-primary" type="submit">Cek Status Bantuan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
