# Tasbih Digital GetX — Modul XI

Nama: Erai Bagusalim
NIM: 240605110088
Kelas: Mobile Programmning A
Tanggal praktikum: 15 Oktober 2026

## Menjalankan

Dari folder proyek:

    flutter pub get
    flutter devices
    flutter run -d emulator-5554

Ganti ID device sesuai hasil flutter devices. Alternatif web: flutter run -d chrome.

## Verifikasi

    flutter analyze
    flutter test
    flutter build apk --debug

Enam pengujian lulus; analyzer tidak menemukan masalah. APK telah diinstal dan diuji pada emulator Android. Screenshot asli kondisi 0, 17, 33, satu ketukan tambahan, dan reset tersedia di ../laporan/screenshots/.

## Struktur dan fungsi

- lib/main.dart: GetMaterialApp, tema Material 3 hijau, halaman Home.
- lib/model/: folder model sesuai modul; belum membutuhkan kelas model terpisah.
- lib/view/home.dart: StatelessWidget, Obx untuk counter dan progress, tombol fingerprint/reset.
- lib/viewmodel/tasbih_controller.dart: RxDouble counter/progress, increment sampai 33, reset ke 0.
- test/: pengujian controller, interaksi widget, batas maksimum, serta layar pendek.

Dependensi mengikuti modul: get ^4.6.5 dan simple_circular_progress_bar ^1.0.2. Versi terkunci masing-masing 4.7.3 dan 1.0.2. Indikator memakai LinearProgressIndicator sesuai contoh, sehingga package circular tidak perlu diimpor.

Nama tasbih_getx mengikuti langkah 11.2.a; penyebutan getx_app di bagian lain modul diperlakukan sebagai nama contoh. SingleChildScrollView dan FittedBox mencegah overflow serta angka dua digit turun baris. Fungsi, warna, batas 33, dan rumus progress tetap sesuai modul. Ikon fingerprint adalah tombol ketuk, bukan autentikasi biometrik. State tidak disimpan permanen.

## Laporan dan APK

Laporan PDF dan DOCX berada di ../laporan/.
APK debug: build/app/outputs/flutter-apk/app-debug.apk.
Bukti pengujian: ../laporan/verifikasi/.

Laporan terbaru memakai template laporan praktikum modul 1.docx, dengan cover/logo asli serta struktur I–IV. PDF diekspor langsung dari DOCX melalui Microsoft Word. Untuk regenerasi: python ../laporan/buat_laporan.py (memerlukan python-docx, pywin32, dan Microsoft Word). isi_laporan.json merupakan bahan laporan versi lama; sumber laporan terbaru adalah sesuaikan_template.py. Versi sebelum penyesuaian disimpan di ../laporan/arsip_sebelum_template/.

