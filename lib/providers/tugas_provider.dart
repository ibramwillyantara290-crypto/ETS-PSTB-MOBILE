import 'package:flutter/foundation.dart';

import '../models/tugas.dart';
import '../services/database_helper.dart';

/// Status pemuatan data untuk UI: loading, sukses (bisa kosong), atau error.
enum StatusMuat { loading, sukses, error }

/// Filter jenis tugas di halaman Beranda dan Selesai.
enum FilterJenis {
  semua('Semua'),
  kuliah('Kuliah'),
  organisasi('Organisasi');

  const FilterJenis(this.label);

  final String label;
}

/// Seluruh logika bisnis aplikasi ada di sini, bukan di widget.
class TugasProvider extends ChangeNotifier {
  TugasProvider({DatabaseHelper? db}) : _db = db ?? DatabaseHelper();

  final DatabaseHelper _db;

  List<Tugas> _semua = [];
  StatusMuat _status = StatusMuat.loading;
  String? _pesanError;
  String? _pesanAksi;
  FilterJenis _filter = FilterJenis.semua;

  // ---- State untuk UI ----
  StatusMuat get status => _status;
  String? get pesanError => _pesanError;

  /// Pesan error dari aksi tambah/ubah/hapus terakhir (null jika sukses).
  String? get pesanAksi => _pesanAksi;
  FilterJenis get filter => _filter;

  /// Tugas belum selesai (sudah difilter), diurutkan dari deadline terdekat.
  List<Tugas> get tugasAktif {
    final hasil = _terapkanFilter(_semua.where((t) => !t.selesai));
    hasil.sort((a, b) => a.deadline.compareTo(b.deadline));
    return hasil;
  }

  /// Tugas yang sudah selesai (sudah difilter), terbaru deadline di atas.
  List<Tugas> get tugasSelesai {
    final hasil = _terapkanFilter(_semua.where((t) => t.selesai));
    hasil.sort((a, b) => b.deadline.compareTo(a.deadline));
    return hasil;
  }

  // ---- Statistik (tanpa filter) ----
  int get totalTugas => _semua.length;
  int get jumlahSelesai => _semua.where((t) => t.selesai).length;
  int get jumlahAktif => totalTugas - jumlahSelesai;
  int get jumlahTerlambat => _semua.where((t) => t.terlambat).length;
  int get jumlahPrioritasTinggi => _semua
      .where((t) => !t.selesai && t.hitungPrioritas() == Prioritas.tinggi)
      .length;
  int get totalJamAktif => _semua
      .where((t) => !t.selesai)
      .fold<int>(0, (jumlah, t) => jumlah + t.estimasiJam);
  int get jumlahKuliah =>
      _semua.where((t) => t.jenis == JenisTugas.kuliah).length;
  int get jumlahOrganisasi =>
      _semua.where((t) => t.jenis == JenisTugas.organisasi).length;
  double get persenSelesai =>
      totalTugas == 0 ? 0.0 : jumlahSelesai / totalTugas;

  /// Tugas aktif dengan deadline paling dekat, atau null jika tidak ada.
  Tugas? get tugasTerdekat {
    final aktif = _semua.where((t) => !t.selesai).toList()
      ..sort((a, b) => a.deadline.compareTo(b.deadline));
    return aktif.isEmpty ? null : aktif.first;
  }

  Tugas? cariById(int? id) {
    if (id == null) return null;
    for (final t in _semua) {
      if (t.id == id) return t;
    }
    return null;
  }

  // ---- Aksi ----
  void setFilter(FilterJenis nilai) {
    if (_filter == nilai) return;
    _filter = nilai;
    notifyListeners();
  }

  /// Memuat semua tugas dari database.
  Future<void> muatTugas({bool tampilkanLoading = true}) async {
    if (tampilkanLoading) {
      final berubah = _status != StatusMuat.loading;
      _status = StatusMuat.loading;
      if (berubah) notifyListeners();
    }
    try {
      _semua = await _db.getAllTugas();
      _status = StatusMuat.sukses;
      _pesanError = null;
    } catch (e) {
      _status = StatusMuat.error;
      _pesanError = 'Gagal memuat data tugas. ($e)';
    }
    notifyListeners();
  }

  Future<bool> tambah(Tugas tugas) {
    return _jalankanAksi(
      () async {
        await _db.insertTugas(tugas);
      },
      'Gagal menambah tugas',
    );
  }

  Future<bool> ubah(Tugas tugas) {
    if (tugas.id == null) {
      _pesanAksi = 'Tugas belum tersimpan, tidak bisa diubah';
      return Future.value(false);
    }
    return _jalankanAksi(
      () async {
        await _db.updateTugas(tugas);
      },
      'Gagal menyimpan perubahan',
    );
  }

  Future<bool> hapus(int id) {
    return _jalankanAksi(
      () async {
        await _db.deleteTugas(id);
      },
      'Gagal menghapus tugas',
    );
  }

  Future<bool> toggleSelesai(Tugas tugas) {
    return ubah(tugas.copyWith(selesai: !tugas.selesai));
  }

  // ---- Helper private ----
  List<Tugas> _terapkanFilter(Iterable<Tugas> sumber) {
    return sumber.where((t) {
      switch (_filter) {
        case FilterJenis.semua:
          return true;
        case FilterJenis.kuliah:
          return t.jenis == JenisTugas.kuliah;
        case FilterJenis.organisasi:
          return t.jenis == JenisTugas.organisasi;
      }
    }).toList();
  }

  /// Menjalankan aksi database lalu memuat ulang data. Mengembalikan true
  /// jika berhasil; jika gagal, pesan ada di [pesanAksi].
  Future<bool> _jalankanAksi(
    Future<void> Function() aksi,
    String pesanGagal,
  ) async {
    try {
      await aksi();
      _semua = await _db.getAllTugas();
      _pesanAksi = null;
      notifyListeners();
      return true;
    } catch (e) {
      _pesanAksi = '$pesanGagal. ($e)';
      return false;
    }
  }
}
