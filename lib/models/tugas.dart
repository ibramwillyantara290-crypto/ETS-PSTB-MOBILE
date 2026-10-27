/// Jenis tugas yang disimpan di database (kolom `jenis`).
class JenisTugas {
  JenisTugas._();

  static const String kuliah = 'kuliah';
  static const String organisasi = 'organisasi';
}

/// Tingkat prioritas tugas. Cara menghitungnya berbeda untuk tiap jenis tugas.
enum Prioritas {
  rendah('Rendah'),
  sedang('Sedang'),
  tinggi('Tinggi');

  const Prioritas(this.label);

  final String label;
}

/// Kelas induk (abstract) untuk semua jenis tugas.
///
/// Atribut dibuat private (`_`) dan hanya bisa dibaca lewat getter
/// (encapsulation). Perilaku yang berbeda tiap jenis tugas dideklarasikan
/// sebagai anggota abstract dan di-override oleh kelas turunan (polymorphism).
abstract class Tugas {
  Tugas({
    int? id,
    required String judul,
    String deskripsi = '',
    required DateTime deadline,
    required int estimasiJam,
    bool selesai = false,
  })  : _id = id,
        _judul = judul,
        _deskripsi = deskripsi,
        _deadline = deadline,
        _estimasiJam = estimasiJam,
        _selesai = selesai;

  final int? _id;
  final String _judul;
  final String _deskripsi;
  final DateTime _deadline;
  final int _estimasiJam;
  final bool _selesai;

  int? get id => _id;
  String get judul => _judul;
  String get deskripsi => _deskripsi;
  DateTime get deadline => _deadline;
  int get estimasiJam => _estimasiJam;
  bool get selesai => _selesai;

  /// Selisih hari antara hari ini dan deadline (negatif jika sudah lewat).
  int get sisaHari {
    final sekarang = DateTime.now();
    final hariIni = DateTime.utc(sekarang.year, sekarang.month, sekarang.day);
    final hariDeadline =
        DateTime.utc(_deadline.year, _deadline.month, _deadline.day);
    return hariDeadline.difference(hariIni).inDays;
  }

  /// True jika belum selesai tetapi deadline sudah lewat.
  bool get terlambat => !_selesai && sisaHari < 0;

  // ---- Anggota abstract: wajib di-override oleh kelas turunan ----

  /// Kunci jenis untuk database ('kuliah' / 'organisasi').
  String get jenis;

  /// Label jenis untuk ditampilkan di UI.
  String get labelJenis;

  /// Satu baris info khusus jenis tugas (mis. nama mata kuliah).
  String get infoTambahan;

  /// Detail khusus jenis tugas untuk halaman detail (label -> nilai).
  Map<String, String> get detailKhusus;

  /// Menghitung prioritas dengan aturan yang berbeda untuk tiap jenis.
  Prioritas hitungPrioritas();

  /// Membuat salinan dengan sebagian atribut diganti.
  Tugas copyWith({
    int? id,
    String? judul,
    String? deskripsi,
    DateTime? deadline,
    int? estimasiJam,
    bool? selesai,
  });

  /// Konversi ke Map untuk SQLite. Kelas turunan menambah kolom miliknya.
  Map<String, Object?> toMap() {
    return {
      'id': _id,
      'jenis': jenis,
      'judul': _judul,
      'deskripsi': _deskripsi,
      'deadline': _deadline.toIso8601String(),
      'estimasi_jam': _estimasiJam,
      'selesai': _selesai ? 1 : 0,
    };
  }
}
