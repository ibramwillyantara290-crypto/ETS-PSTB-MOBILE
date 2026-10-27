import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'app_routes.dart';
import 'providers/tugas_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Di Android/iOS sqflite jalan langsung. Di desktop (Windows/Linux/macOS)
  // sqflite memerlukan FFI, jadi factory-nya diganti.
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  await initializeDateFormatting('id_ID');
  runApp(const SobadKampusApp());
}

class SobadKampusApp extends StatelessWidget {
  const SobadKampusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TugasProvider()..muatTugas(),
      child: MaterialApp(
        title: 'Sobad Kampus',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFF2E7D6B),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorSchemeSeed: const Color(0xFF2E7D6B),
        ),
        initialRoute: AppRoutes.beranda,
        onGenerateRoute: AppRoutes.generate,
      ),
    );
  }
}
