import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tugas_provider.dart';

/// Deretan chip untuk memfilter tugas berdasarkan jenis.
class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final filterAktif = context.select<TugasProvider, FilterJenis>(
      (p) => p.filter,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final f in FilterJenis.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(f.label),
                selected: filterAktif == f,
                onSelected: (_) => context.read<TugasProvider>().setFilter(f),
              ),
            ),
        ],
      ),
    );
  }
}
