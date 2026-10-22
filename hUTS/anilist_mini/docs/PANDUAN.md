# Panduan pengembangan dan presentasi

## Rancangan
Dua halaman: Home dan Detail. Home menyimpan Future agar rebuild tidak mengirim HTTP berulang. Pencarian lewat tombol/Enter, bukan tiap huruf. Grid 2 kolom di ponsel, 3/4 di layar lebar. Detail mengambil ulang data berdasarkan mal_id. Palet: background #10101C, surface #1C1B2B, purple #8B5CF6, lavender #B39BFF, muted #A9A5BC, rating #F8C95C.

## Membuat project dari awal
```sh
flutter doctor
flutter create --platforms=android,web anilist_mini
cd anilist_mini
flutter pub add http
code .
flutter devices
flutter run -d chrome
```
Project sudah dibuat; jangan menjalankan create lagi pada folder yang sama. Untuk Android, pasang Android SDK melalui Android Studio, jalankan emulator dari Device Manager atau hubungkan perangkat dengan USB debugging. Gunakan `flutter doctor --android-licenses` bila diminta, lalu `flutter run -d <DEVICE_ID>`.

## Penjelasan file
### lib/models/anime_model.dart
Class model adalah bentuk data anime yang bertipe jelas. JSON adalah format pertukaran data berbentuk objek/list. Factory fromJson membaca Map dan menghasilkan AnimeModel. Poster berasal dari images -> jpg -> image_url. Operator ?. melindungi akses null, ?? memberi pengganti. Angka JSON dibaca sebagai num lalu dikonversi. score null ditampilkan sebagai tidak tersedia; episodes/year tetap nullable. Genre menjadi List<String>.
Kalimat presentasi: “Saya memisahkan parsing agar tampilan tidak perlu membaca JSON mentah.” Model tidak mengirim HTTP; dipanggil service setelah decoding.

### lib/services/anime_service.dart
Service memiliki fetchTopAnime, searchAnime, fetchAnimeDetail. Client.get dari package http menjalankan GET; penggunaan Client memudahkan pengujian tanpa jaringan. Future merupakan hasil yang tersedia nanti, async memungkinkan await, await menunggu tanpa memblokir UI. Status 2xx diterima; 429 memberi pesan khusus; timeout 20 detik, jaringan gagal dan JSON rusak diubah ke AnimeException. jsonDecode mengubah teks menjadi objek Dart, lalu fromJson menghasilkan model. Uri.https mengodekan query termasuk spasi dan &. Jeda minimum 400 ms mengurangi lonjakan, tetapi bukan jaminan terhadap seluruh batas server. Tidak ada retry otomatis tanpa batas.
Kalimat presentasi: “Service mengurus komunikasi, validasi, dan parsing; halaman mengurus tampilan.”

### lib/main.dart
main menjalankan runApp. MaterialApp mengatur judul, Material 3, tema gelap, dan HomePage. Konstanta warna dipakai kedua halaman. Tidak mengambil API secara langsung.
Kalimat presentasi: “File ini adalah pintu masuk dan pengaturan tampilan global.”

### lib/pages/home_page.dart
StatefulWidget menyimpan controller, service dan Future. initState memulai top anime. setState mengganti Future saat cari/refresh. FutureBuilder memeriksa waiting, error, lalu data. List kosong mendapat empty state. GridView.builder membangun kartu sesuai kebutuhan. Image.network memuat poster API dengan errorBuilder sebagai fallback. Navigator.push membuka DetailPage. Controller dibersihkan di dispose.
Kalimat presentasi: “Future tidak dibuat di build supaya perubahan tampilan tidak memboroskan request.” Refresh kembali ke Top Anime dan membersihkan pencarian. Saat ini request tombol berulang tetap mungkin; service hanya memberi jeda. Halaman pertama dibatasi 24 hasil, belum pagination.

### lib/pages/detail_page.dart
DetailPage menerima model dari kartu dan memanggil endpoint /anime/{id}. Future disimpan di initState; retry menggantinya. FutureBuilder menampilkan loading/error/detail. Konten dapat digulir; genre memakai Wrap. AppBar otomatis memberi tombol kembali karena route ditambahkan lewat push. Jika year tidak tersedia ditampilkan '-'.
Kalimat presentasi: “ID dari kartu menjadi penghubung daftar dengan endpoint detail.”

### pubspec.yaml dan konfigurasi
pubspec menyatakan Flutter, batas Dart dan package http. Import `package:http/http.dart` memberi akses HTTP. flutter_test dan flutter_lints adalah alat pengembangan. AndroidManifest.xml memerlukan izin INTERNET untuk build non-debug. Folder android dan web dibuat Flutter, bukan arsitektur tambahan.

## Alur singkat
Pengguna membuka aplikasi -> initState -> service GET -> pemeriksaan HTTP -> jsonDecode -> AnimeModel.fromJson -> Future selesai -> FutureBuilder menampilkan grid. Cari mengganti query; klik kartu membawa model/ID ke detail.

## Tanya jawab presentasi
- Mengapa Flutter? Satu basis Dart, widget UI lengkap, mendukung async dan banyak platform.
- Mengapa Jikan? Menyediakan metadata anime publik tanpa API key untuk kebutuhan tugas.
- Apakah AniList Mini memakai API AniList? Tidak; nama aplikasi ini berbeda dari penyedia data Jikan/MyAnimeList.
- Mengapa tidak HTTP dalam build? build dapat dipanggil berulang tanpa interaksi jaringan yang diperlukan.
- Apa beda jsonDecode dan fromJson? Decode mengubah string menjadi Map/List; factory mengubah Map menjadi model bertipe.
- Mengapa ada FutureBuilder? UI mengikuti proses asinkron: waiting, error, success.
- Bagaimana hasil kosong? Success dengan list kosong, bukan kegagalan jaringan.
- Bagaimana diuji? Unit test model/service dan widget test menggunakan data uji; manual/live harus dibuktikan terpisah.
- Apakah semua fitur sudah terbukti di perangkat? Belum; lihat tabel pengujian, jangan menyamakan mock dengan jaringan nyata.

## GitHub
Buat repository kosong bernama anilist_mini di GitHub, pilih Public. Dari root project:
```sh
git init
git add .
git commit -m "Implement AniList Mini untuk UTS"
git branch -M main
git remote add origin https://github.com/<USERNAME>/anilist_mini.git
git push -u origin main
```
Ganti placeholder sendiri, gunakan otorisasi GitHub yang aman, jangan menulis token dalam source. Periksa .gitignore agar build, .dart_tool, local.properties dan kredensial tidak terunggah. Buka URL repo tanpa login untuk memastikan akses. Perintah ini adalah panduan, belum dijalankan untuk publikasi.

## Laporan dan Google Drive
Lengkapi nama, NIM, jurusan, perguruan tinggi dan logo resmi. Ambil screenshot asli. Cocokkan tabel hasil aktual. Setelah disetujui, ekspor laporan A4 ke PDF, upload Drive, Share -> General access -> Anyone with the link -> Viewer. Uji link incognito tanpa login. Dua link yang dikumpulkan adalah repository public dan PDF Drive. Tenggat dari PDF: 29 Oktober 2026 pukul 23.59 WIB.
