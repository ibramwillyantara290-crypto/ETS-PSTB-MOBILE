import 'package:flutter/material.dart';

import '../models/tugas.dart';

/// Label kecil berwarna untuk menampilkan prioritas tugas.
class PrioritasBadge extends StatelessWidget {
  const PrioritasBadge({super.key, required this.prioritas});

  final Prioritas prioritas;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final skema = tema.colorScheme;
    final Color latar;
    final Color teks;
    switch (prioritas) {
      case Prioritas.tinggi:
        latar = skema.errorContainer;
        teks = skema.onErrorContainer;
      case Prioritas.sedang:
        latar = skema.tertiaryContainer;
        teks = skema.onTertiaryContainer;
      case Prioritas.rendah:
        latar = skema.secondaryContainer;
        teks = skema.onSecondaryContainer;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: latar,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        prioritas.label,
        style: tema.textTheme.labelSmall?.copyWith(
          color: teks,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
