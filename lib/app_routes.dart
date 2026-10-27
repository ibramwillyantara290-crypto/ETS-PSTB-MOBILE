import 'package:flutter/material.dart';

import 'models/tugas.dart';
import 'pages/detail_page.dart';
import 'pages/form_page.dart';
import 'pages/home_shell.dart';

/// Named routes. Data dikirim lewat `RouteSettings.arguments` dan
/// divalidasi tipenya di sini sebelum halaman dibuat.
class AppRoutes {
  AppRoutes._();

  static const String beranda = '/';
  static const String detail = '/detail';
  static const String form = '/form';

  static Route<dynamic> generate(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case beranda:
        return _halaman(settings, const HomeShell());
      case detail:
        if (args is Tugas) {
          return _halaman(settings, DetailPage(tugasAwal: args));
        }
        return _halamanError('Data tugas tidak valid.');
      case form:
        if (args == null) return _halaman(settings, const FormPage());
        if (args is Tugas) return _halaman(settings, FormPage(tugas: args));
        return _halamanError('Data tugas tidak valid.');
      default:
        return _halamanError('Halaman "${settings.name}" tidak ditemukan.');
    }
  }

  static MaterialPageRoute<void> _halaman(RouteSettings s, Widget halaman) {
    return MaterialPageRoute<void>(settings: s, builder: (_) => halaman);
  }

  static MaterialPageRoute<void> _halamanError(String pesan) {
    return MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Terjadi kesalahan')),
        body: Center(child: Text(pesan)),
      ),
    );
  }
}
