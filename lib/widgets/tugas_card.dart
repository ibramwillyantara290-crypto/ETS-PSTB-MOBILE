import 'package:flutter/material.dart';

import '../models/tugas.dart';
import '../utils/format_tanggal.dart';
import 'prioritas_badge.dart';

/// Kartu tugas untuk daftar di halaman Beranda.
class TugasCard extends StatelessWidget {
  const TugasCard({
    super.key,
    required this.tugas,
    required this.onTap,
    required this.onToggle,
  });

  final Tugas tugas;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skema = tema.colorScheme;
    final warnaDeadline =
        tugas.terlambat ? skema.error : skema.onSurfaceVariant;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 8, 12, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: tugas.selesai,
                onChanged: (_) => onToggle(),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tugas.judul,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: tema.textTheme.titleMedium?.copyWith(
                          decoration: tugas.selesai
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${tugas.labelJenis} · ${tugas.infoTambahan}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: skema.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${teksSisaHari(tugas)} · ${formatTanggal(tugas.deadline)}',
                        style: tema.textTheme.bodySmall?.copyWith(
                          color: warnaDeadline,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: PrioritasBadge(prioritas: tugas.hitungPrioritas()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
