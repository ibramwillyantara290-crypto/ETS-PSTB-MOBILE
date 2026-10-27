import 'tugas.dart';

/// Tugas organisasi/kepanitiaan: punya nama organisasi.
class TugasOrganisasi extends Tugas {
  TugasOrganisasi({
    super.id,
    required super.judul,
    super.deskripsi,
    required super.deadline,
    required super.estimasiJam,
    super.selesai,
    required String namaOrganisasi,
  }) : _namaOrganisasi = namaOrganisasi;

  factory TugasOrganisasi.fromMap(Map<String, Object?> map) {
    return TugasOrganisasi(
      id: map['id'] as int?,
      judul: map['judul'] as String,
      deskripsi: (map['deskripsi'] as String?) ?? '',
      deadline: DateTime.parse(map['deadline'] as String),
      estimasiJam: map['estimasi_jam'] as int,
      selesai: (map['selesai'] as int) == 1,
      namaOrganisasi: (map['nama_organisasi'] as String?) ?? '',
    );
  }

  final String _namaOrganisasi;

  String get namaOrganisasi => _namaOrganisasi;

  @override
  String get jenis => JenisTugas.organisasi;

  @override
  String get labelJenis => 'Organisasi';

  @override
  String get infoTambahan => _namaOrganisasi;

  @override
  Map<String, String> get detailKhusus => {'Organisasi': _namaOrganisasi};

  /// Tugas organisasi lebih longgar: tinggi jika tersisa <= 1 hari,
  /// sedang jika <= 3 hari.
  @override
  Prioritas hitungPrioritas() {
    if (selesai) return Prioritas.rendah;
    if (sisaHari <= 1) return Prioritas.tinggi;
    if (sisaHari <= 3) return Prioritas.sedang;
    return Prioritas.rendah;
  }

  @override
  TugasOrganisasi copyWith({
    int? id,
    String? judul,
    String? deskripsi,
    DateTime? deadline,
    int? estimasiJam,
    bool? selesai,
  }) {
    return TugasOrganisasi(
      id: id ?? this.id,
      judul: judul ?? this.judul,
      deskripsi: deskripsi ?? this.deskripsi,
      deadline: deadline ?? this.deadline,
      estimasiJam: estimasiJam ?? this.estimasiJam,
      selesai: selesai ?? this.selesai,
      namaOrganisasi: _namaOrganisasi,
    );
  }

  @override
  Map<String, Object?> toMap() {
    return {
      ...super.toMap(),
      'nama_organisasi': _namaOrganisasi,
    };
  }
}
