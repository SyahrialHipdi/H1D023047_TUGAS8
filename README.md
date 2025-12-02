# pertemuan11

Repositori ini adalah aplikasi contoh kecil yang menampilkan daftar produk dengan operasi CRUD dan alur autentikasi/registrasi sederhana. Tujuannya untuk menunjukkan struktur proyek Flutter yang menggunakan lapisan `bloc` sederhana yang berinteraksi dengan helper `Api` dan `ApiUrl` untuk endpoint.

## Halaman & Komponen (UI)

### main.dart

- Titik masuk aplikasi.
- Menetapkan `ProdukPage()` sebagai halaman utama (`home`).


## Cara Kerja Login & Registrasi (Alur)

- Endpoint utama:

  - `POST /registrasi` → untuk membuat akun baru
  - `POST /login` → untuk autentikasi dan mendapatkan token

- Alur Registrasi:

  1. Pengguna membuka `registrasi_page.dart` dan mengisi: `nama`, `email`, `password`, `konfirmasi password`.
  2. Form divalidasi oleh UI (misal: panjang password minimal, email valid).
  3. Saat submit, `RegistrasiBloc.registrasi(...)` dipanggil. `RegistrasiBloc` memanggil `Api().post(ApiUrl.registrasi, body)`.
  4. Di backend CI4, biasanya server menerima JSON pada body:
     ```json
     { "nama": "Budi", "email": "budi@example.com", "password": "123456" }
     ```
  5. Jika pembuatan sukses server mengembalikan status `201` atau `200` dengan body JSON — UI akan menampilkan dialog sukses. Kalau gagal (400/422), UI menampilkan error.

- Alur Login:
  1. Pengguna membuka `login_page.dart`, mengisi `email` dan `password`.
  2. Saat submit, `LoginBloc.login(email: ..., password: ...)` dipanggil; `Api().post(ApiUrl.login, body)` membuat request.
  3. Body JSON untuk login misal:
     ```json
     { "email": "budi@example.com", "password": "123456" }
     ```
  4. Jika login sukses server mengembalikan JSON berisi token dan data user (status code 200).
  5. `LoginBloc` mem-parse JSON ke model `Login`. `login_page.dart` menyimpan token dan userId ke `UserInfo().setToken(...)` dan `UserInfo().setUserID(...)` sehingga token dapat dipakai pada request berikutnya.
  6. Setelah login, UI akan menavigasi pengguna ke `ProdukPage()`.

> Catatan: `lib/helpers/api.dart` menambahkan header `Authorization: Bearer <token>` secara otomatis untuk request yang membutuhkan otentikasi — hanya kalau token ada.

---

## Cara Kerja CRUD Produk (Alur & Endpoint)

- Endpoint (contoh):

  - `GET /produk` → ambil daftar produk
  - `POST /produk` → tambah produk
  - `PUT /produk/{id}/update` → perbarui data produk
  - `DELETE /produk/{id}` → hapus produk

- Alur Read (Menampilkan daftar produk):

  1. `ProdukPage` memanggil `ProdukBloc.getProduks()` yang memanggil `Api().get(ApiUrl.listProduk)`.
  2. `Api` mengirim HTTP GET ke endpoint; response 200 berisi JSON list produk.
  3. `ProdukBloc` mengubah body JSON menjadi `List<Produk>` lalu UI menampilkan list.

- Alur Create:

  1. `ProdukForm` mengumpulkan field `kodeProduk`, `namaProduk`, `harga`.
  2. Memanggil `ProdukBloc.addProduk(...)` yang panggil `Api().post(ApiUrl.createProduk, body)` dengan body JSON seperti:
     ```json
     { "kode_produk": "PRD001", "nama": "Contoh", "harga": 10000 }
     ```
  3. Jika sukses (kode 200/201), server mengembalikan objek baru; UI menutup form dan memuat ulang daftar.

- Alur Update:

  1. `ProdukPage` membuka `ProdukForm` untuk produk terpilih (mengirim data ke form).
  2. Setelah submit, `ProdukBloc.updateProduk(...)` memanggil `Api().put(ApiUrl.updateProduk(id), body)`.
  3. Server memproses dan mengembalikan success (200). UI memperbarui list dengan data baru.

- Alur Delete:
  1. `ProdukDetail` menampilkan tombol `Delete`.
  2. Konfirmasi lalu `ProdukBloc.deleteProduk(id)` dipanggil: `Api().delete(ApiUrl.deleteProduk(id))`.
  3. Server merespon status (200), UI menghapus item dari list dan menampilkan pesan sukses.

---

## Header & Token

- Token disimpan menggunakan `helpers/user_info.dart` (SharedPreferences):
  - `UserInfo().setToken(token)` saat login berhasil.
  - `UserInfo().getToken()` digunakan pada `Api` untuk menambahkan header `Authorization` (format: `Bearer <token>`).

## Payload & Response (Contoh)

- Registrasi sukses (201/200) contoh body:
  ```json
  { "code": 201, "status": true, "data": "User created" }
  ```
- Login sukses (200) contoh body:
  ```json
  {
    "code": 200,
    "status": true,
    "data": {
      "token": "xxxx.yyyy.zzzz",
      "user": { "id": "1", "email": "budi@example.com" }
    }
  }
  ```
- CRUD produk (GET list) contoh body:
  ```json
  {
    "code": 200,
    "status": true,
    "data": [{"id":1,"kode_produk":"PRD001","nama":"Contoh","harga":10000}, ...]
  }
  ```

---

## Contoh Debugging (cURL)

- Registrasi:

```powershell
curl.exe -v http://192.168.1.15:8080/registrasi -Method POST -ContentType "application/json" -Body '{"nama":"Budi","email":"budi@example.com","password":"123456"}'
```

- Login:

```powershell
curl.exe -v http://192.168.1.15:8080/login -Method POST -ContentType "application/json" -Body '{"email":"budi@example.com","password":"123456"}'
```

- Jika Anda menggunakan emulator Android: ganti `192.168.1.15` menjadi `10.0.2.2` pada `ApiUrl.baseUrl`.

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
<img width="643" height="1027" alt="image" src="https://github.com/user-attachments/assets/5a1476dc-c328-4407-a3e0-39ae2e8687ab" />

<img width="644" height="1030" alt="image" src="https://github.com/user-attachments/assets/60cc4b9e-0172-418d-b24a-43dce9a265a7" />

<img width="642" height="1034" alt="image" src="https://github.com/user-attachments/assets/4bcf00ba-f286-46e0-a6c1-f8a9c1ca4ad1" />

<img width="640" height="855" alt="image" src="https://github.com/user-attachments/assets/36fd9244-135b-4792-9ad9-618fea26388d" />

<img width="641" height="847" alt="image" src="https://github.com/user-attachments/assets/e45fbcd9-6b49-469b-bad9-56de4ce91ab9" />

<img width="641" height="858" alt="image" src="https://github.com/user-attachments/assets/09d89c6e-b081-4251-a9ed-0ea0767fd10a" />




