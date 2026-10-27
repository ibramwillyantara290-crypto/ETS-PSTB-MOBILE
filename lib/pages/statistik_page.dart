import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_routes.dart';
import '../providers/tugas_provider.dart';
import '../utils/format_tanggal.dart';
import '../widgets/kartu_stat.dart';
import '../widgets/progres_ring.dart';
import '../widgets/state_views.dart';

/// Halaman 3: ringkasan progres dan statistik tugas.
class StatistikPage extends StatelessWidget {
  const StatistikPage({super.key});

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
            ikon: Icons.insights_outlined,
            judul: 'Belum ada data',
            pesan: 'Statistik muncul setelah kamu menambahkan tugas.',
          );
        }
        return _Isi(provider: provider);
    }
  }
}

class _Isi extends StatelessWidget {
  const _Isi({required this.provider});

  final TugasProvider provider;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final terdekat = provider.tugasTerdekat;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            children: [
              ProgresRing(nilai: provider.persenSelesai),
              const SizedBox(height: 12),
              Text(
                '${provider.jumlahSelesai} dari ${provider.totalTugas} tugas selesai',
                style: tema.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, kendala) {
                  final lebar = (kendala.maxWidth - 12) / 2;
                  final kartu = <Widget>[
                    KartuStat(
                      ikon: Icons.pending_actions,
                      angka: '${provider.jumlahAktif}',
                      label: 'Tugas aktif',
                    ),
                    KartuStat(
                      ikon: Icons.warning_amber_rounded,
                      angka: '${provider.jumlahTerlambat}',
                      label: 'Terlambat',
                    ),
                    KartuStat(
                      ikon: Icons.priority_high,
                      angka: '${provider.jumlahPrioritasTinggi}',
                      label: 'Prioritas tinggi',
                    ),
                    KartuStat(
                      ikon: Icons.timer_outlined,
                      angka: '${provider.totalJamAktif} jam',
                      label: 'Estimasi sisa kerja',
                    ),
                    KartuStat(
                      ikon: Icons.school_outlined,
                      angka: '${provider.jumlahKuliah}',
                      label: 'Tugas kuliah',
                    ),
                    KartuStat(
                      ikon: Icons.groups_outlined,
                      angka: '${provider.jumlahOrganisasi}',
                      label: 'Tugas organisasi',
                    ),
                  ];
                  return Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final k in kartu) SizedBox(width: lebar, child: k),
                    ],
                  );
                },
              ),
              if (terdekat != null) ...[
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    leading: const Icon(Icons.alarm),
                    title: Text(
                      terdekat.judul,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      'Deadline terdekat · ${teksSisaHari(terdekat)} · ${formatTanggal(terdekat.deadline)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRoutes.detail,
                      arguments: terdekat,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
