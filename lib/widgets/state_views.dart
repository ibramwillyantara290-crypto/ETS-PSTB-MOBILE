import 'package:flutter/material.dart';

/// Tampilan saat data sedang dimuat.
class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// Menengahkan [child] dan tetap bisa di-scroll di layar pendek (landscape).
class KontenTengahScroll extends StatelessWidget {
  const KontenTengahScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, kendala) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: kendala.maxHeight),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

/// Tampilan saat data kosong. Set [kompak] true jika dipakai di dalam list.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    required this.ikon,
    required this.judul,
    required this.pesan,
    this.kompak = false,
  });

  final IconData ikon;
  final String judul;
  final String pesan;
  final bool kompak;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final isi = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(ikon, size: 64, color: tema.colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            judul,
            textAlign: TextAlign.center,
            style: tema.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            pesan,
            textAlign: TextAlign.center,
            style: tema.textTheme.bodyMedium?.copyWith(
              color: tema.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
    if (kompak) return Center(child: isi);
    return KontenTengahScroll(child: isi);
  }
}

/// Tampilan saat terjadi error, dengan tombol coba lagi.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.pesan, required this.onCoba});

  final String pesan;
  final VoidCallback onCoba;

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return KontenTengahScroll(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 64, color: tema.colorScheme.error),
            const SizedBox(height: 12),
            Text(
              'Terjadi kesalahan',
              textAlign: TextAlign.center,
              style: tema.textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              pesan,
              textAlign: TextAlign.center,
              style: tema.textTheme.bodyMedium?.copyWith(
                color: tema.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onCoba,
              icon: const Icon(Icons.refresh),
              label: const Text('Coba lagi'),
            ),
          ],
        ),
      ),
    );
  }
}
