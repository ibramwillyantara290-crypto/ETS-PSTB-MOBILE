import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../providers/tugas_provider.dart';
import '../utils/aksi_tugas.dart';
import '../widgets/filter_bar.dart';
import '../widgets/state_views.dart';
import '../widgets/tugas_grid_card.dart';

/// Halaman 2: tugas yang sudah selesai, ditampilkan sebagai grid.
class SelesaiPage extends StatelessWidget {
  const SelesaiPage({super.key});

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
        final daftar = provider.tugasSelesai;
        // Tinggi kartu mengikuti ukuran teks sistem agar tidak overflow.
        final skalaTeks = MediaQuery.textScalerOf(context).scale(14) / 14;
        final tinggiKartu = 128.0 * skalaTeks.clamp(1.0, 2.0).toDouble();

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilterBar(),
              ),
            ),
            Expanded(
              child: daftar.isEmpty
                  ? const EmptyView(
                      ikon: Icons.hourglass_empty,
                      judul: 'Belum ada tugas selesai',
                      pesan: 'Centang tugas di Beranda untuk memindahkannya ke sini.',
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 320,
                        mainAxisExtent: tinggiKartu,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      itemCount: daftar.length,
                      itemBuilder: (context, indeks) {
                        final tugas = daftar[indeks];
                        return TugasGridCard(
                          tugas: tugas,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.detail,
                            arguments: tugas,
                          ),
                          onKembalikan: () => ubahStatusTugas(context, tugas),
                        );
                      },
                    ),
            ),
          ],
        );
    }
  }
}
