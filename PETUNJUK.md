# Sobad Kampus: cara pasang

1. Ekstrak zip ini ke folder project `aplikasi` (gabungkan, timpa `lib/main.dart` dan `test/widget_test.dart`).
2. Di terminal, dari folder project:

   ```
   flutter pub remove bloc flutter_bloc
   flutter pub add provider sqflite sqflite_common_ffi path intl
   flutter pub get
   ```

3. Nyalakan emulator Android (atau sambungkan HP), lalu `flutter run`.
   - Di target Windows, `sqflite_common_ffi` sudah dipakai otomatis. Jika muncul error `sqlite3.dll`, jalankan di emulator Android saja, atau tambahkan `flutter pub add sqlite3_flutter_libs`.
4. Cek kode: `flutter analyze` lalu `flutter test`.
5. Jika nama package di `pubspec.yaml` bukan `aplikasi`, ganti `package:aplikasi/` di `test/widget_test.dart`.

## Struktur

```
lib/
  main.dart            MultiProvider, tema, init database desktop
  app_routes.dart      named routes + validasi arguments
  models/              Tugas (abstract), TugasKuliah, TugasOrganisasi, tugas_factory
  services/            DatabaseHelper (singleton, CRUD async)
  providers/           TugasProvider (ChangeNotifier, semua logika bisnis)
  pages/               home_shell (NavigationBar), beranda, selesai, statistik, detail, form
  widgets/             kartu, badge, filter, progres ring, loading/kosong/error
  utils/               validator, format tanggal, aksi bersama
```

## Pemetaan ke ketentuan ETS

| Ketentuan | Lokasi |
|---|---|
| Abstract class + 2 turunan, override | `models/tugas.dart`, `tugas_kuliah.dart`, `tugas_organisasi.dart` (`hitungPrioritas`, `labelJenis`, `detailKhusus`, `copyWith`, `toMap`) |
| Encapsulation | atribut `_private` + getter di `Tugas`, `TugasKuliah`, `TugasOrganisasi` |
| Layout variatif | Container, Row, Column, Expanded, Stack (`progres_ring.dart`), ListView.builder (Beranda), GridView.builder (Selesai) |
| Responsif | `maxWidth` pada konten, grid `MaxCrossAxisExtent`, `KontenTengahScroll`, semua halaman bisa di-scroll |
| 3+ halaman, NavigationBar, push/pop + data | `home_shell.dart`, `app_routes.dart` (arguments `Tugas` divalidasi) |
| Provider | `providers/tugas_provider.dart`, dipakai lewat `context.watch/read/select` |
| SQLite singleton + CRUD async | `services/database_helper.dart` |
| State loading / kosong / error | `StatusMuat` + `widgets/state_views.dart` |
| Form + validasi | `pages/form_page.dart`, `utils/validator.dart` (wajib, min/maks panjang, angka+rentang, email, tanggal) |
| Input pilihan | Dropdown (jenis), DatePicker (deadline), Checkbox (selesai) |
| keyboardType, loading submit, SnackBar | `form_page.dart` |
