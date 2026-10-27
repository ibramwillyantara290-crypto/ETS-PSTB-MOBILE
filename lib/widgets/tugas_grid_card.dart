import 'package:flutter/material.dart';

import '../models/tugas.dart';
import '../utils/format_tanggal.dart';

/// Kartu ringkas untuk GridView di halaman Selesai.
/// Tinggi kartu ditentukan oleh `mainAxisExtent` pada grid-nya.
class TugasGridCard extends StatelessWidget {
  const TugasGridCard({
    super.key,
    required this.tugas,
    required this.onTap,
    required this.onKembalikan,
  });

  final Tugas tugas;
  final VoidCallback onTap;
  final VoidCallback onKembalikan;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skema = tema.colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle, size: 20, color: skema.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tugas.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.titleSmall,
                    ),
                  ),
                ],
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
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatTanggal(tugas.deadline),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: tema.textTheme.labelSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Kembalikan ke aktif',
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    constraints:
                        const BoxConstraints.tightFor(width: 36, height: 36),
                    onPressed: onKembalikan,
                    icon: const Icon(Icons.undo),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
