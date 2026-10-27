import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../models/tugas.dart';
import '../providers/tugas_provider.dart';
import '../utils/aksi_tugas.dart';
import '../utils/format_tanggal.dart';
import '../widgets/prioritas_badge.dart';

/// Detail satu tugas. Datanya dikirim lewat `arguments` pada named route.
class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.tugasAwal});

  final Tugas tugasAwal;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    // Ambil versi terbaru dari provider supaya ikut berubah setelah diedit.
    final tugas =
        context.watch<TugasProvider>().cariById(tugasAwal.id) ?? tugasAwal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail tugas'),
        actions: [
          IconButton(
            tooltip: 'Ubah',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.form,
              arguments: tugas,
            ),
          ),
          IconButton(
            tooltip: 'Hapus',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _konfirmasiHapus(context, tugas),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tugas.judul, style: tema.textTheme.headlineSmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Chip(label: Text(tugas.labelJenis)),
                      PrioritasBadge(prioritas: tugas.hitungPrioritas()),
                      Chip(label: Text(teksSisaHari(tugas))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (tugas.deskripsi.isNotEmpty) ...[
                    Text('Deskripsi', style: tema.textTheme.titleSmall),
                    const SizedBox(height: 4),
                    Text(tugas.deskripsi),
                    const SizedBox(height: 16),
                  ],
                  Card(
                    margin: EdgeInsets.zero,
                    child: Column(
                      children: [
                        _Baris(
                          ikon: Icons.event,
                          label: 'Deadline',
                          nilai: formatTanggal(tugas.deadline),
                        ),
                        _Baris(
                          ikon: Icons.timer_outlined,
                          label: 'Estimasi pengerjaan',
                          nilai: '${tugas.estimasiJam} jam',
                        ),
                        for (final e in tugas.detailKhusus.entries)
                          _Baris(
                            ikon: Icons.label_outline,
                            label: e.key,
                            nilai: e.value,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => ubahStatusTugas(context, tugas),
                      icon: Icon(tugas.selesai ? Icons.undo : Icons.check),
                      label: Text(
                        tugas.selesai
                            ? 'Tandai belum selesai'
                            : 'Tandai selesai',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _konfirmasiHapus(BuildContext context, Tugas tugas) async {
    final id = tugas.id;
    if (id == null) return;

    final yakin = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus tugas?'),
        content: Text('"${tugas.judul}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (yakin != true || !context.mounted) return;

    final provider = context.read<TugasProvider>();
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();

    final berhasil = await provider.hapus(id);
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            berhasil
                ? 'Tugas dihapus'
                : (provider.pesanAksi ?? 'Gagal menghapus tugas'),
          ),
        ),
      );
  }
}

class _Baris extends StatelessWidget {
  const _Baris({required this.ikon, required this.label, required this.nilai});

  final IconData ikon;
  final String label;
  final String nilai;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListTile(
      leading: Icon(ikon),
      title: Text(
        label,
        style: tema.textTheme.bodySmall?.copyWith(
          color: tema.colorScheme.onSurfaceVariant,
        ),
      ),
      subtitle: Text(nilai, style: tema.textTheme.bodyLarge),
    );
  }
}
