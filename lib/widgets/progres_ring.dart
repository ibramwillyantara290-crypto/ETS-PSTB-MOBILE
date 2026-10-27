import 'package:flutter/material.dart';

/// Lingkaran progres dengan persentase di tengah (memakai Stack).
class ProgresRing extends StatelessWidget {
  const ProgresRing({super.key, required this.nilai, this.ukuran = 160});

  /// Nilai 0.0 sampai 1.0.
  final double nilai;
  final double ukuran;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return SizedBox(
      width: ukuran,
      height: ukuran,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: nilai,
              strokeWidth: 12,
              backgroundColor: tema.colorScheme.surfaceContainerHighest,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(nilai * 100).round()}%',
                style: tema.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('selesai', style: tema.textTheme.labelMedium),
            ],
          ),
        ],
      ),
    );
  }
}
