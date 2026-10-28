# SIPANDU — Sistem Informasi Pelacakan dan Transparansi Bantuan Sosial

**Mata Kuliah:** Pengembangan Aplikasi Berbasis Web (SIF302) & Manajemen Proyek Teknologi Informasi (MPTI)  
**Semester:** Gasal 2026/2027 · Program Studi Informatika · Universitas Islam Indonesia  
**Kelompok:** Kelompok 2 - STRES  
**Repository GitHub:** [https://github.com/GrexLy/sipandu-bansos](https://github.com/GrexLy/sipandu-bansos)

## 1. Ringkasan Proyek & Proses Bisnis

**SIPANDU (Sistem Informasi Pelacakan dan Transparansi Bantuan Sosial)** adalah platform berbasis web yang dirancang untuk mendigitalkan proses pengelolaan data penerima, verifikasi kelayakan, pencatatan distribusi di titik pencairan, pelacakan status penyaluran bantuan sosial secara transparan hingga diterima oleh warga/Kelompok Penerima Manfaat (KPM), serta pengelolaan pengaduan masyarakat secara terstruktur.

- **Cakupan Rancangan Arsitektur (MPTI — Project Charter Utama):** Mendukung layanan bantuan sosial pada wilayah **Provinsi Daerah Istimewa Yogyakarta (DIY)** menggunakan arsitektur *Multi-Tenant* dan *Role-Based Access Control (RBAC)* secara berjenjang dari tingkat Provinsi, Kabupaten/Kota, Kapanewon/Kemantren, hingga Kalurahan/Kelurahan.
- **Cakupan Validasi Prototipe Akademik (PABW — Lingkup Implementasi & Demo Expo):** Validasi sistem dan pengujian fungsional dilakukan melalui prototipe terbatas pada **satu kalurahan/kelurahan (Kelurahan Sumberharjo yang terdiri dari beberapa RW)** menggunakan **data kependudukan dummy** dan **simulasi *mock API***, sehingga ruang lingkup tetap terukur dan dapat didemonstrasikan secara utuh (*end-to-end*) pada saat expo.

### Tiga Langkah Proses Bisnis Utama yang Didigitalkan
1. **Pendataan & Verifikasi Kelayakan Penerima:** Mencatat data calon penerima bantuan sosial (KPM) dan memverifikasi kesesuaiannya terhadap basis data kependudukan dummy / *mock API* untuk mencegah duplikasi NIK dan ketidaktepatan sasaran, disertai pencatatan riwayat perubahan status verifikasi.
2. **Pengelolaan Program, Titik Pencairan, & Pelacakan Status Distribusi:** Mengelola program bantuan sosial, periode penyaluran, dan lokasi titik pencairan per wilayah/RW, serta memperbarui tahapan status penyaluran bantuan secara kronologis mulai dari titik pencairan hingga dikonfirmasi telah diterima oleh warga/KPM.
3. **Portal Transparansi Publik (Cek Status Mandiri) & Pengaduan Online:** Menyediakan portal web bagi warga/KPM untuk mengecek perkembangan status bantuan mereka secara mandiri (dengan perlindungan data pribadi) serta mengirimkan laporan pengaduan online apabila terjadi ketidaksesuaian data atau bantuan belum diterima.

## 2. Rumusan Masalah & Dampak Operasional (Lembar A.1)

| Komponen Identifikasi | Deskripsi |
| :--- | :--- |
| **Masalah Utama** | Proses pendataan dan verifikasi kelayakan calon penerima bantuan sosial serta pelacakan status distribusi bantuan dari titik pencairan hingga diterima oleh warga/KPM masih belum terstruktur, rawan ketidaksesuaian atau duplikasi data, dan sulit dipantau secara transparan baik antarwilayah maupun oleh masyarakat. |
| **Frekuensi Kejadian** | Terjadi secara berulang pada setiap periode penetapan dan penyaluran program bantuan sosial, mulai dari tahap pendataan awal, verifikasi kriteria kependudukan, distribusi di titik pencairan tiap RW/kalurahan, hingga konfirmasi penerimaan dan penanganan keluhan warga. |
| **Akibat Bila Tidak Terbantu** | 1. **Ketidaktepatan sasaran bantuan:** Risiko lolosnya data penerima ganda (duplikasi NIK), data tidak lengkap, atau warga yang tidak memenuhi kriteria program.<br>2. **Keterbatasan pelacakan distribusi:** Pergerakan bantuan dari titik pencairan hingga diterima warga tidak tercatat secara kronologis, sehingga menyulitkan pengawasan dan rawan menimbulkan sengketa distribusi.<br>3. **Minimnya transparansi & lambatnya tindak lanjut keluhan:** Warga tidak memiliki kepastian informasi mengenai status pencairan bantuan serta kesulitan melaporkan ketidaksesuaian data atau bantuan yang belum diterima. |
| **Dasar Identifikasi** | Hasil pemetaan alur proses bisnis (*business flow*), penyusunan *Business Requirement Document (BRD)*, dan analisis kebutuhan pengguna pada Milestone M1 (*Project Planning & Charter*) serta Milestone M2 (*Analisis Kebutuhan & Desain Arsitektur*) di mata kuliah MPTI. |

## 3. Pelaku / Aktor Sistem

| Aktor / Peran | Deskripsi & Hak Akses dalam Sistem |
| :--- | :--- |
| **Operator Berjenjang / Petugas Kelurahan (Admin, Verifikator, & Petugas Penyalur)** | Mengelola data program bantuan sosial dan titik pencairan sesuai kewenangan wilayahnya (*Role-Based Access Control / RBAC*), melakukan verifikasi kelayakan calon penerima/KPM terhadap data kependudukan dummy / *mock API*, memperbarui tahapan status distribusi bantuan hingga diterima warga, serta menindaklanjuti laporan pengaduan yang masuk. |
| **Warga Penerima / Kelompok Penerima Manfaat (KPM)** | Mengakses Portal Transparansi Publik / Pengecekan Status untuk memantau tahapan penyaluran bantuan sosial dan lokasi titik pencairan secara mandiri, serta mengajukan dan memantau laporan pada modul Pengaduan Online. |
| **Dinas Sosial DIY / Kab. Sleman & Pemerintah Kalurahan** | Pemangku kepentingan utama (*Client & Sponsor*) yang mengawasi akuntabilitas alokasi program, ketepatan sasaran penerima, dan ketertiban penyaluran bantuan sosial. |

## 4. Daftar Fitur Wajib & User Story Awal (Lembar B.2 & B.3)

### Lima Fitur Wajib (Cakupan M4–M6)
1. **Verifikasi Kelayakan Calon Penerima/KPM:** Mengelola data calon penerima dan memverifikasi kelayakan berdasarkan basis data kependudukan dummy / *mock API* beserta pencatatan riwayat status verifikasi.
2. **Manajemen Program Bantuan & Titik Pencairan:** Mengelola informasi program bantuan sosial, jenis bantuan, periode penyaluran, alokasi wilayah/RW, dan lokasi titik pencairan.
3. **Pelacakan Status Distribusi Bantuan (★ Fitur Penentu Manfaat Utama):** Mencatat dan memperbarui status tahapan penyaluran bantuan mulai dari alokasi di titik pencairan, proses penyaluran, hingga konfirmasi diterima oleh warga/KPM.
4. **Portal Pengecekan Status Mandiri (Transparansi Publik):** Menyediakan pencarian status penyaluran bantuan dan informasi titik pencairan secara mandiri bagi warga dengan tetap menjaga perlindungan data pribadi.
5. **Pengaduan Online Terintegrasi:** Menyediakan formulir pelaporan kendala/ketidaksesuaian bantuan bagi warga beserta fitur kategorisasi, penugasan, dan pemantauan status tindak lanjut bagi petugas.

### Tiga User Story Utama
- **US-01 (Verifikasi Penerima):** *Sebagai* Petugas/Operator Verifikator, *saya ingin* memeriksa dan memverifikasi data calon penerima bantuan berdasarkan basis data kependudukan dummy / *mock API* di dalam sistem *agar* hanya warga yang memenuhi kriteria dan bebas dari duplikasi NIK yang ditetapkan sebagai penerima bantuan sosial.
- **US-02 (Pelacakan Distribusi):** *Sebagai* Petugas/Operator Penyaluran, *saya ingin* mencatat titik pencairan dan memperbarui status tahapan penyaluran bantuan hingga dikonfirmasi diterima oleh warga/KPM *agar* riwayat distribusi bantuan di setiap wilayah/RW tercatat secara kronologis dan transparan.
- **US-03 (Cek Status & Pengaduan Warga):** *Sebagai* Warga Penerima Bantuan (KPM), *saya ingin* mengecek status penyaluran bantuan sosial secara mandiri dan mengirimkan pengaduan online apabila bantuan belum diterima atau data tidak sesuai *agar* saya memperoleh kepastian informasi penyaluran serta dapat melaporkan kendala dengan cepat.

### Batasan Ruang Lingkup (Out of Scope)
1. Tidak mencakup pengembangan *dashboard* analitik/prediktif (*Business Intelligence*) sesuai kesepakatan pengampu MPTI & PABW.
2. Tidak melakukan integrasi produksi langsung ke database pemerintah nyata (Dukcapil/DTSEN/Kemensos); verifikasi disimulasikan dengan tabel kependudukan dummy / *mock API*.
3. Tidak mengembangkan aplikasi *mobile native* (Android/iOS), fitur transfer/pencairan dana digital langsung (*payment gateway*), AI/*Machine Learning*, maupun perangkat IoT.

## 5. Anggota Kelompok 2 - STRES & Pembagian Peran

| NIM | Nama Anggota | Peran Utama | Tanggung Jawab Awal & Target Sebelum P17 |
| :---: | :--- | :--- | :--- |
| **25523171** | **Muhammad Rifqi Van Baker** | Project Manager | Mengoordinasikan jadwal milestone M1–M9, menyelaraskan ruang lingkup MPTI & PABW, menginisiasi repository Git & `README.md`, mengatur *branch*, serta memfinalisasi proposal P17. |
| **25523272** | **Chelsy Alfaddhillah** | System Analyst & UI/UX Designer | Memodelkan alur bisnis (*business flow*) & matriks akses RBAC, memfinalisasi diagram *use case* & *user story*, serta menyiapkan *wireframe* kasar 3 layar utama untuk P17. |
| **25523057** | **Wahyu Nurgholib Razak** | Web Developer (Front-end & Back-end) / DB Developer | Merancang ERD & skema database SQL (`database_schema_sipandu.sql`), struktur proyek PHP & koneksi database, autentikasi/RBAC, serta mengimplementasikan modul aplikasi. |
| **25523233** | **Nur Rahmi Apriliani** | QA Tester & Technical Writer | Menyusun dokumentasi teknis & kriteria uji (*acceptance criteria*), menyiapkan variasi skenario data dummy pengujian (valid, tidak lengkap, NIK ganda), serta melaksanakan pengujian sistem. |

## 6. Struktur Direktori Repository

```text
sipandu-bansos/
├── README.md                          # Dokumentasi utama proyek (Commit Pertama P14)
├── database/
│   └── database_schema_sipandu.sql    # Skema tabel SQL + data dummy awal (Kelurahan Sumberharjo)
├── docs/
│   ├── project-charter/               # Dokumen Project Charter (Versi Kelurahan & Versi Utama MPTI)
│   ├── use-case/                      # Diagram Use Case (B.4) & Spesifikasi User Story (B.2)
│   ├── wireframes/                    # Wireframe kasar 3 layar utama untuk dibawa ke P17
│   └── qa-scenarios/                  # Skenario data dummy & rencana pengujian (QA)
├── public/
│   ├── index.php                      # Halaman utama & Portal Transparansi / Cek Status Mandiri
│   ├── pengaduan.php                  # Halaman form & pelacakan Pengaduan Online warga
│   ├── login.php                      # Halaman autentikasi petugas/operator (RBAC)
│   └── assets/
│       ├── css/                       # Stylesheet antarmuka web
│       └── js/                        # Script validasi input & interaksi antarmuka
└── src/
    ├── config/
    │   └── database.php               # Konfigurasi koneksi PDO MySQL/MariaDB
    ├── middleware/
    │   └── auth_rbac.php              # Pemeriksaan sesi login, peran (RBAC), & cakupan wilayah
    ├── modules/
    │   ├── verifikasi/                # Modul pengelolaan calon KPM & verifikasi (Mock API/Dummy)
    │   ├── program_titik/             # Modul pengelolaan program bantuan & titik pencairan
    │   ├── distribusi/                # Modul pembaruan & pelacakan status penyaluran (★ Fitur Inti)
    │   └── pengaduan/                 # Modul pengelolaan & tindak lanjut pengaduan online
    └── views/
        └── layouts/                   # Komponen header, navigasi, dan footer aplikasi
```

## 7. Panduan Alur Kerja Git (Target Luar Kelas Sebelum P17)

Sesuai bagian **C.2 Worksheet P14**, setiap anggota kelompok mempraktikkan alur cabang (*branch*) dan *Pull Request (PR)* sebelum Pertemuan 17:

1. **Inisialisasi & Commit Pertama (Project Manager — Rifqi):**
   ```bash
   git init
   git branch -M main
   git add README.md
   git commit -m "docs: inisialisasi README proses bisnis, masalah, pelaku, dan anggota kelompok"
   git remote add origin https://github.com/GrexLy/sipandu-bansos.git
   git push -u origin main
   ```
2. **Cabang Skema Database & Struktur Awal (Web/DB Developer — Wahyu):**
   ```bash
   git checkout -b feat/database-schema-awal
   git add database/database_schema_sipandu.sql
   git commit -m "feat(db): tambah skema tabel SQL multi-tenant dan seed data dummy awal"
   git push -u origin feat/database-schema-awal
   ```
   *(Buka tautan di browser untuk membuat Pull Request ke branch `main` di GitHub dan simpan tautan PR untuk dibawa ke P17).*
3. **Cabang Dokumentasi Use Case & Wireframe 3 Layar (System Analyst & UI/UX — Chelsy):**
   ```bash
   git checkout -b docs/usecase-dan-wireframe
   git add docs/use-case/ docs/wireframes/
   git commit -m "docs(design): tambah diagram use case dan rancangan wireframe 3 layar utama"
   git push -u origin docs/usecase-dan-wireframe
   ```
4. **Cabang Skenario Data Dummy & Acceptance Criteria (QA & Technical Writer — Nur Rahmi):**
   ```bash
   git checkout -b docs/skenario-qa-dummy
   git add docs/qa-scenarios/
   git commit -m "docs(qa): tambah skenario uji data dummy valid, duplikat, dan tidak lengkap"
   git push -u origin docs/skenario-qa-dummy
   ```
