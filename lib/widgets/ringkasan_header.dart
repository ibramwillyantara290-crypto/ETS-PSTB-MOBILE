import 'package:flutter/material.dart';

/// Tiga kotak ringkasan di bagian atas Beranda.
class RingkasanHeader extends StatelessWidget {
  const RingkasanHeader({
    super.key,
    required this.aktif,
    required this.terlambat,
    required this.selesai,
  });

  final int aktif;
  final int terlambat;
  final int selesai;

  @override
  Widget build(BuildContext context) {
    final skema = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: _Kotak(angka: aktif, label: 'Aktif')),
        const SizedBox(width: 8),
        Expanded(
          child: _Kotak(
            angka: terlambat,
            label: 'Terlambat',
            warnaAngka: terlambat > 0 ? skema.error : null,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: _Kotak(angka: selesai, label: 'Selesai')),
      ],
    );
  }
}

class _Kotak extends StatelessWidget {
  const _Kotak({required this.angka, required this.label, this.warnaAngka});

  final int angka;
  final String label;
  final Color? warnaAngka;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: tema.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$angka',
            maxLines: 1,
            style: tema.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: warnaAngka,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: tema.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
