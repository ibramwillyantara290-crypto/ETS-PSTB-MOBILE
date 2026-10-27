import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../providers/tugas_provider.dart';
import '../utils/aksi_tugas.dart';
import '../widgets/filter_bar.dart';
import '../widgets/ringkasan_header.dart';
import '../widgets/state_views.dart';
import '../widgets/tugas_card.dart';

/// Halaman 1: daftar tugas yang belum selesai.
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TugasProvider>();

    switch (provider.status) {
      case StatusMuat.loading:
        return const LoadingView();
      case StatusMuat.error:
        return ErrorView(
          pesan: provider.pesanError ?? 'Data tidak bisa dimuat.',
          onCoba: () => provider.muatTugas(),
        );
      case StatusMuat.sukses:
        if (provider.totalTugas == 0) {
          return const EmptyView(
            ikon: Icons.assignment_outlined,
            judul: 'Belum ada tugas',
            pesan: 'Tekan tombol "Tugas baru" untuk mencatat tugas pertamamu.',
          );
        }
        return _DaftarTugas(provider: provider);
    }
  }
}

class _DaftarTugas extends StatelessWidget {
  const _DaftarTugas({required this.provider});

  final TugasProvider provider;

  @override
  Widget build(BuildContext context) {
    final daftar = provider.tugasAktif;

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: RefreshIndicator(
          onRefresh: () => provider.muatTugas(tampilkanLoading: false),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            // Item 0 = header. Jika daftar kosong (karena filter), item 1
            // menampilkan pesan kosong.
            itemCount: daftar.isEmpty ? 2 : daftar.length + 1,
            itemBuilder: (context, indeks) {
              if (indeks == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RingkasanHeader(
                        aktif: provider.jumlahAktif,
                        terlambat: provider.jumlahTerlambat,
                        selesai: provider.jumlahSelesai,
                      ),
                      const SizedBox(height: 12),
                      const FilterBar(),
                    ],
                  ),
                );
              }
              if (daftar.isEmpty) {
                return const EmptyView(
                  kompak: true,
                  ikon: Icons.celebration_outlined,
                  judul: 'Tidak ada tugas aktif',
                  pesan: 'Semua tugas di kategori ini sudah selesai.',
                );
              }
              final tugas = daftar[indeks - 1];
              return TugasCard(
                tugas: tugas,
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.detail,
                  arguments: tugas,
                ),
                onToggle: () => ubahStatusTugas(context, tugas),
              );
            },
          ),
        ),
      ),
    );
  }
}
