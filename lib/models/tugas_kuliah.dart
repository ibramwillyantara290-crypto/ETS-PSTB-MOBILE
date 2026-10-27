import 'tugas.dart';

/// Tugas perkuliahan: punya mata kuliah dan (opsional) email dosen.
class TugasKuliah extends Tugas {
  TugasKuliah({
    super.id,
    required super.judul,
    super.deskripsi,
    required super.deadline,
    required super.estimasiJam,
    super.selesai,
    required String mataKuliah,
    String emailDosen = '',
  })  : _mataKuliah = mataKuliah,
        _emailDosen = emailDosen;

  factory TugasKuliah.fromMap(Map<String, Object?> map) {
    return TugasKuliah(
      id: map['id'] as int?,
      judul: map['judul'] as String,
      deskripsi: (map['deskripsi'] as String?) ?? '',
      deadline: DateTime.parse(map['deadline'] as String),
      estimasiJam: map['estimasi_jam'] as int,
      selesai: (map['selesai'] as int) == 1,
      mataKuliah: (map['mata_kuliah'] as String?) ?? '',
      emailDosen: (map['email_dosen'] as String?) ?? '',
    );
  }

  final String _mataKuliah;
  final String _emailDosen;

  String get mataKuliah => _mataKuliah;
  String get emailDosen => _emailDosen;

  @override
  String get jenis => JenisTugas.kuliah;

  @override
  String get labelJenis => 'Kuliah';

  @override
  String get infoTambahan => _mataKuliah;

  @override
  Map<String, String> get detailKhusus => {
        'Mata kuliah': _mataKuliah,
        if (_emailDosen.isNotEmpty) 'Email dosen': _emailDosen,
      };

  /// Tugas kuliah lebih ketat: tinggi jika tersisa <= 2 hari,
  /// sedang jika <= 5 hari atau pengerjaannya lama (>= 8 jam).
  @override
  Prioritas hitungPrioritas() {
    if (selesai) return Prioritas.rendah;
    if (sisaHari <= 2) return Prioritas.tinggi;
    if (sisaHari <= 5 || estimasiJam >= 8) return Prioritas.sedang;
    return Prioritas.rendah;
  }

  @override
  TugasKuliah copyWith({
    int? id,
    String? judul,
    String? deskripsi,
    DateTime? deadline,
    int? estimasiJam,
    bool? selesai,
  }) {
    return TugasKuliah(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      deadline: deadline ?? this.deadline,
      estimasiJam: estimasiJam ?? this.estimasiJam,
      selesai: selesai ?? this.selesai,
      mataKuliah: _mataKuliah,
      emailDosen: _emailDosen,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      'mata_kuliah': _mataKuliah,
      'email_dosen': _emailDosen,
    };
  }
}
