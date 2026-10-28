# Catatan pengujian AniList Mini

Pengujian otomatis dijalankan dengan `flutter test`, `flutter analyze` dan `flutter build web`. Unit test memakai response fixture/MockClient, bukan server live. Endpoint publik api.jikan.moe sudah dihentikan. Endpoint pengganti Tenrai live diverifikasi untuk Top Anime, pencarian, dan detail; uji manual UI/device tetap belum dilakukan. Belum ada Android emulator terdeteksi saat pemeriksaan awal. Pengujian visual/manual perangkat masih harus dilakukan dan tidak boleh ditandai lulus berdasarkan widget test saja.

| No. | Fitur | Skenario | Hasil yang diharapkan | Hasil aktual | Status |
|---:|---|---|---|---|---|
|1|Aplikasi dijalankan|`flutter build web`|Build berhasil tanpa error|Build web berhasil; belum run manual|Lulus build; manual belum diuji|
|2|Top Anime|Service menerima respons JSON 200|Data model list terbentuk|Fixture UI lulus; Tenrai live mengembalikan HTTP 200 dan judul Sousou no Frieren|Lulus otomatis dan endpoint live|
|3|Poster|Buka aplikasi dengan jaringan dan gambar tersedia|Poster API tampil; jika gagal ada fallback|Tidak diverifikasi live|Belum diuji manual|
|4|Judul dan rating|Fixture model pada widget|Judul dan score tampak|Widget test menemukan judul dan 9.1|Lulus otomatis|
|5|Pencarian|Masukkan query dan tekan Cari|Service menerima query encoded dan UI merender hasil|Service test memeriksa query `a & b`; Tenrai live untuk Naruto merespons HTTP 200|Lulus service dan endpoint live; UI manual belum diuji|
|6|Pencarian tanpa hasil|Fixture hasil kosong|Empty state “Anime tidak ditemukan”|Widget test menemukan empty state|Lulus otomatis|
|7|Navigasi detail|Ketuk kartu anime|Route detail terbuka|Belum ada widget test navigasi|Belum diuji manual|
|8|Data detail|GET endpoint id mengembalikan JSON|Detail model tersedia|Mock test memeriksa `/v1/anime/5114`; Tenrai live merespons Fullmetal Alchemist: Brotherhood|Lulus otomatis dan endpoint live|
|9|Loading|Tunda respons jaringan|Progress indicator tampak|Belum ada test tertunda/manual|Belum diuji|
|10|Gangguan koneksi|Putus internet|Pesan ramah serta retry tampil|Service test memeriksa ClientException; UI error state belum widget-tested|Lulus service fixture; manual belum diuji|
|11|Retry|Ketuk Coba Lagi setelah error|Request baru dikirim|Belum ada widget test retry|Belum diuji manual|
|12|Refresh|Tekan ikon refresh|Top Anime diminta ulang dan query dibersihkan|Belum ada widget test aksi refresh|Belum diuji manual|
|13|Tombol kembali|Kembali dari detail|Route kembali ke home|Belum ada widget test navigasi|Belum diuji manual|
|14|HTTP non-2xx|Mock status 429/500|AnimeException dapat ditampilkan|Unit test 429 dan 500 lulus|Lulus otomatis|
|15|JSON invalid/null data|Mock body tidak sesuai|Kesalahan parsing ditangani|Unit test invalid, {} dan data:null lulus|Lulus otomatis|
|16|Model JSON|JSON lengkap serta field opsional null|Model membuat nilai aman|Dua unit test model lulus|Lulus otomatis|
|17|Static analysis|`flutter analyze`|Tidak ada issue|No issues found|Lulus|

## Langkah uji manual yang masih perlu dilakukan
1. Jalankan `flutter devices`; mulai Android emulator di Android Studio Device Manager atau pakai Chrome.
2. Jalankan `flutter run -d <DEVICE_ID>` dengan koneksi internet stabil. Verifikasi data dan gambar API.
3. Cari `Naruto`, tekan Cari, lalu pastikan judul hasil sesuai.
4. Cari string acak yang tidak umum, pastikan empty state tampil; gunakan tombol untuk kembali.
5. Buka satu kartu, periksa rating, genre, status dan sinopsis; tekan back.
6. Uji refresh. Ambil screenshot asli Home, hasil pencarian, detail dan loading.
7. Uji error saat API tidak dapat dicapai. Jangan mengharuskan Jikan outage; mode pesawat dapat membantu menguji kegagalan jaringan dan retry setelah internet aktif.
8. Simpan screenshot error/loading asli bila kondisi berhasil direproduksi dan catat tanggal/perangkat. Jika tidak, tandai belum diuji.
