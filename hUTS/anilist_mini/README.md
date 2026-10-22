# AniList Mini

Aplikasi discovery anime berbasis Flutter untuk UTS Pemrograman Mobile. Data berasal dari Jikan API v4 (API tidak resmi MyAnimeList), bukan layanan AniList.co.

## Fitur
- Top Anime, pencarian lewat tombol/Enter, dan detail anime melalui endpoint terpisah.
- Poster, judul, rating, episode, status, genre, tipe, tahun, dan sinopsis.
- Loading, success, error dengan retry, empty state, dan fallback gambar.
- Refresh Top Anime; grid dua kolom pada ponsel, tiga/empat pada layar lebar.
- Dark mode Material 3. Tidak ada favorites, pagination, filter genre, atau penyimpanan lokal.

## Teknologi
Flutter, Dart, package http; setState dan FutureBuilder tanpa library state management.

## API
Base aktif: https://api.tenrai.org/v1 (kompatibel dengan skema Jikan v4)
- GET /top/anime?limit=24
- GET /anime?q={judul}&limit=24
- GET /anime/{mal_id}
Dokumentasi: https://api.tenrai.org/documentation

Catatan migrasi: endpoint publik Jikan `api.jikan.moe` telah dihentikan pada 1 Oktober 2026. Karena tugas menetapkan Jikan API sebagai acuan, aplikasi memakai Tenrai sebagai pengganti drop-in yang mengimplementasikan skema Jikan v4.
Data dan gambar dimiliki penyedia aslinya. Jikan tidak berafiliasi dengan aplikasi ini.

## Struktur
```text
lib/
  main.dart
  models/anime_model.dart
  services/anime_service.dart
  pages/home_page.dart
  pages/detail_page.dart
test/                   # Unit dan widget test
docs/                   # Panduan, hasil uji, dan laporan draf
android/                # Konfigurasi Android, termasuk izin INTERNET
web/                    # Konfigurasi web bawaan Flutter
pubspec.yaml
```

## Instalasi
SDK pengembangan yang dipakai: Flutter 3.47.2 / Dart 3.13.2. Pasang Flutter dari https://docs.flutter.dev/install dan extension Flutter/Dart di VS Code.
```bash
git clone <URL_REPOSITORY_GITHUB>
cd anilist_mini
flutter doctor
flutter pub get
code .
flutter devices
flutter run -d chrome
```
Android: buka emulator melalui Android Studio Device Manager atau aktifkan USB debugging pada perangkat, lalu `flutter run -d <DEVICE_ID>`. Izin INTERNET sudah disertakan di manifest utama.

## Pengujian dan build
```bash
flutter test
flutter analyze
flutter build web
flutter build apk --debug
```
Tes menggunakan fixture/mock yang hanya ada di folder test, bukan data aplikasi produksi. Endpoint publik Jikan `api.jikan.moe` sudah dihentikan; endpoint pengganti Tenrai live diverifikasi untuk Top Anime, pencarian Naruto, dan detail anime/5114 dengan HTTP 200. Build web dan APK debug berhasil; ini tidak sama dengan keberhasilan pengujian manual di Android. Lihat docs/PENGUJIAN.md.

## Screenshot
Belum tersedia. Tambahkan screenshot asli home, search, detail, loading, dan error sesudah menjalankan aplikasi; jangan mengganti dengan desain ilustrasi.

## Identitas
Nama: [NAMA MAHASISWA]  
NIM: [NIM]  
Jurusan: [JURUSAN]  
Perguruan tinggi: [PERGURUAN TINGGI]

## Publikasi
Repository belum diunggah. Lihat docs/PANDUAN.md untuk perintah Git dan panduan akses Google Drive. Laporan masih draf sampai bukti manual, identitas, serta logo asli dilengkapi.
