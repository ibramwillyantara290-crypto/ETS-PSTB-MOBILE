import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/tugas.dart';
import '../models/tugas_factory.dart';

/// Akses SQLite dengan pola singleton: seluruh aplikasi memakai satu instance.
class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static const String _namaDatabase = 'sobad_kampus.db';
  static const int _versiDatabase = 1;
  static const String tabelTugas = 'tugas';

  Future<Database>? _bukaDb;

  /// Database dibuka sekali saja (lazy). Jika gagal, percobaan berikutnya
  /// akan mencoba membuka ulang.
  Future<Database> get database => _bukaDb ??= _inisialisasi();

  Future<Database> _inisialisasi() async {
    try {
      final folder = await getDatabasesPath();
      return await openDatabase(
        join(folder, _namaDatabase),
        version: _versiDatabase,
        onCreate: _buatTabel,
      );
    } catch (_) {
      _bukaDb = null;
      rethrow;
    }
  }

  Future<void> _buatTabel(Database db, int versi) async {
    await db.execute('''
      CREATE TABLE $tabelTugas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        jenis TEXT NOT NULL,
        judul TEXT NOT NULL,
        deskripsi TEXT NOT NULL DEFAULT '',
        deadline TEXT NOT NULL,
        estimasi_jam INTEGER NOT NULL,
        selesai INTEGER NOT NULL DEFAULT 0,
        mata_kuliah TEXT,
        email_dosen TEXT,
        nama_organisasi TEXT
      )
    ''');
  }

  // ---- CREATE ----
  Future<int> insertTugas(Tugas tugas) async {
    final db = await database;
    return db.insert(tabelTugas, tugas.toMap());
  }

  // ---- READ ----
  Future<List<Tugas>> getAllTugas() async {
    final db = await database;
    final baris = await db.query(
      tabelTugas,
      orderBy: 'selesai ASC, deadline ASC',
    );
    return baris.map(tugasDariMap).toList();
  }

  Future<Tugas?> getTugasById(int id) async {
    final db = await database;
    final baris = await db.query(
      tabelTugas,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (baris.isEmpty) return null;
    return tugasDariMap(baris.first);
  }

  // ---- UPDATE ----
  Future<int> updateTugas(Tugas tugas) async {
    final db = await database;
    return db.update(
      tabelTugas,
      tugas.toMap(),
      where: 'id = ?',
      whereArgs: [tugas.id],
    );
  }

  // ---- DELETE ----
  Future<int> deleteTugas(int id) async {
    final db = await database;
    return db.delete(tabelTugas, where: 'id = ?', whereArgs: [id]);
  }
}
