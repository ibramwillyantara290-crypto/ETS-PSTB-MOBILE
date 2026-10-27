import 'tugas.dart';
import 'tugas_kuliah.dart';
import 'tugas_organisasi.dart';

/// Membuat objek [Tugas] dengan kelas turunan yang tepat dari baris database.
Tugas tugasDariMap(Map<String, Object?> map) {
  final jenis = map['jenis'];
  if (jenis == JenisTugas.kuliah) return TugasKuliah.fromMap(map);
  if (jenis == JenisTugas.organisasi) return TugasOrganisasi.fromMap(map);
  throw FormatException('Jenis tugas tidak dikenal: $jenis');
}
