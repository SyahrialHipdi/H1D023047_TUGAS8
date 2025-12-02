# pertemuan10

Repositori ini adalah aplikasi contoh kecil yang menampilkan daftar produk dengan operasi CRUD dan alur autentikasi/registrasi sederhana. Tujuannya untuk menunjukkan struktur proyek Flutter yang menggunakan lapisan `bloc` sederhana yang berinteraksi dengan helper `Api` dan `ApiUrl` untuk endpoint.

## Halaman & Komponen (UI)

### main.dart

- Titik masuk aplikasi.
- Menetapkan `ProdukPage()` sebagai halaman utama (`home`).


### login_page.dart

- Tujuan: Form sederhana untuk login (email & password).
- Komponen dan Perilaku Utama:
  - `TextFormField` untuk `email` dan `password` serta validasi.
  - `ElevatedButton` untuk Login: memvalidasi form sebelum lanjut (saat ini menampilkan simulasi loading).
  - `InkWell` untuk navigasi ke halaman Registrasi.
- Integrasi:
  - Ada `LoginBloc` untuk memanggil API login. Saat ini UI menggunakan simulasi delay untuk demonstrasi; bisa diganti dengan panggilan `LoginBloc.login()`.


### registrasi_page.dart

- Tujuan: Form registrasi pengguna.
- Komponen dan Perilaku Utama:
  - Field: `Nama`, `Email`, `Password`, `Konfirmasi Password`.
  - Validasi sisi-klien:
    - Nama >= 3 karakter
    - Email harus diisi dan valid
    - Password >= 6 karakter
    - Konfirmasi Password sama dengan Password
  - Tombol Registrasi: menampilkan indikator loading dan saat ini mensimulasikan panggilan jaringan. Jika berhasil, form di-clear dan menampilkan snack bar.
- Integrasi:
  - Tersedia `RegistrasiBloc` untuk memanggil endpoint registrasi. UI saat ini menggunakan simulasi — Anda dapat mengkoneksikannya ke bloc untuk panggilan nyata.


### produk_page.dart

- Tujuan: Menampilkan daftar produk, navigasi untuk menambah produk, dan menu logout.
- Komponen dan Perilaku Utama:
  - `AppBar` dengan tombol Add yang menavigasi ke `ProdukForm`.
  - `Drawer` berisi `Logout` (action masih stub).
  - `ListView` menampilkan beberapa contoh `ItemProduk` (hard-coded sebagai contoh).
  - `ItemProduk`: kartu yang bisa diklik untuk membuka `ProdukDetail`.


### produk_form.dart

- Tujuan: Menambah atau mengubah produk.
- Komponen dan Perilaku Utama:
  - Menerima opsi `Produk` untuk edit dan menginisialisasi field bila ada.
  - Field: `Kode Produk`, `Nama Produk`, `Harga`.
  - Validasi: memeriksa isian tidak kosong dan `Harga` numerik.
  - Saat submit:
    - Mem-validasi form di sisi-klien.
    - Menampilkan indikator loading.
    - Mensimulasikan panggilan jaringan — bisa diganti dengan `ProdukBloc.addProduk` atau `ProdukBloc.updateProduk`.
  - Menutup/`dispose()` TextEditingController.

---

### produk_detail.dart

- Tujuan: Menampilkan detail produk serta tombol edit/hapus.
- Komponen dan Perilaku Utama:
  - Menampilkan `kodeProduk`, `namaProduk`, dan `hargaProduk`.
  - Tombol Edit: navigasi ke `ProdukForm` dengan value produk.
  - Tombol Hapus: menampilkan dialog konfirmasi, bila Ya: memanggil `ProdukBloc.deleteProduk(id: ...)` dan kembali ke `ProdukPage` bila berhasil, atau menampilkan `WarningDialog` bila gagal.

---

## Lapisan Bloc

Lapisan bloc dalam proyek ini berupa sekumpulan fungsi statis yang memanggil helper `Api` dan mem-parse response menjadi model.

### login_bloc.dart

- `LoginBloc.login({String? email, String? password})` — memanggil `Api().post(...)` dan mengembalikan model `Login`.

### registrasi_bloc.dart

- `RegistrasiBloc.registrasi(...)` — memanggil endpoint `registrasi` dan mengembalikan model `Registrasi`.

### produk_bloc.dart

- Fungsi CRUD:
  - `getProduks()` — memanggil `Api().get()` lalu mengembalikan `List<Produk>`.
  - `addProduk({Produk? produk})` — memanggil API create.
  - `updateProduk({required Produk produk})` — memanggil API update.
  - `deleteProduk({int? id})` — memanggil API delete dan mengembalikan boolean status.

---

## Model

- `model/login.dart` — model `Login` (token, userID, userEmail).
- `model/registrasi.dart` — model `Registrasi` (code, status, data).
- `model/produk.dart` — model `Produk`.

Semua model memiliki factory `fromJson(Map<String, dynamic> obj)` untuk mem-parse response API.

---

## Helpers

- `helpers/api.dart` — wrapper `Api` yang menggunakan `http` untuk `get`, `post`, `put`, `delete`.
- `helpers/api_url.dart` — konstan endpoint API (baseUrl, login, registrasi, dll.).
- `helpers/user_info.dart` — pembungkus `SharedPreferences` untuk menyimpan token dan user id (set/get/clear).

---

## Widget Kustom

- `widget/success_dialog.dart` — dialog untuk menampilkan pesan berhasil.
- `widget/warning_dialog.dart` — dialog untuk menampilkan pesan gagal/peringatan.

---

## Lampiran
<img width="804" height="1029" alt="image" src="https://github.com/user-attachments/assets/3a4d0077-44ed-404b-b809-a355692669ef" />

<img width="628" height="1030" alt="image" src="https://github.com/user-attachments/assets/989034a5-7f68-446f-bb5b-5775a814c76a" />

<img width="628" height="1080" alt="image" src="https://github.com/user-attachments/assets/f8c7519c-f908-4828-89da-862b87bb7331" />


- Menghubungkan `login_page.dart` ke `LoginBloc` dan menyimpan token menggunakan `UserInfo`.
- Mengganti daftar produk hard-coded menjadi panggilan `ProdukBloc.getProduks()`.

