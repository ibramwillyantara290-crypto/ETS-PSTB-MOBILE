import 'package:flutter/material.dart';

import '../app_routes.dart';
import 'beranda_page.dart';
import 'selesai_page.dart';
import 'statistik_page.dart';

/// Kerangka utama: AppBar, tiga halaman utama, dan NavigationBar.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _indeks = 0;

  static const List<String> _judul = [
    'Sobad Kampus',
    'Tugas Selesai',
    'Statistik',
  ];

  static const List<Widget> _halaman = [
    BerandaPage(),
    SelesaiPage(),
    StatistikPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_indeks])),
      // IndexedStack menjaga posisi scroll tiap halaman saat berpindah tab.
      body: IndexedStack(index: _indeks, children: _halaman),
      floatingActionButton: _indeks == 0
          ? FloatingActionButton.extended(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.form),
              icon: const Icon(Icons.add),
              label: const Text('Tugas baru'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indeks,
        onDestinationSelected: (i) => setState(() => _indeks = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline),
            selectedIcon: Icon(Icons.check_circle),
            label: 'Selesai',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}
