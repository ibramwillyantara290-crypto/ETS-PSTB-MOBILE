import 'package:intl/intl.dart';

import '../models/tugas.dart';

/// Contoh: "Sen, 26 Okt 2026". Butuh `initializeDateFormatting('id_ID')`.
String formatTanggal(DateTime tanggal) {
  return DateFormat('EEE, d MMM yyyy', 'id_ID').format(tanggal);
}

/// Teks sisa waktu, mis. "Besok", "3 hari lagi", "Terlambat 2 hari".
String teksSisaHari(Tugas tugas) {
  if (tugas.selesai) return 'Selesai';
  final sisa = tugas.sisaHari;
  if (sisa < 0) return 'Terlambat ${-sisa} hari';
  if (sisa == 0) return 'Hari ini';
  if (sisa == 1) return 'Besok';
  return '$sisa hari lagi';
}
