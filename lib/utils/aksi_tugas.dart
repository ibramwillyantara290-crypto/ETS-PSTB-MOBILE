import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tugas.dart';
import '../providers/tugas_provider.dart';

/// Mengubah status selesai/belum sebuah tugas dan menampilkan SnackBar.
Future<void> ubahStatusTugas(BuildContext context, Tugas tugas) async {
  final provider = context.read<TugasProvider>();
  final messenger = ScaffoldMessenger.of(context);
  final berhasil = await provider.toggleSelesai(tugas);
  final pesan = berhasil
      ? (tugas.selesai ? 'Dikembalikan ke tugas aktif' : 'Ditandai selesai')
      : (provider.pesanAksi ?? 'Gagal mengubah status tugas');
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(pesan)));
}
