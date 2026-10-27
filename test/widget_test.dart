// Unit test untuk model dan validator (tanpa UI/database).
// Jika nama package di pubspec.yaml bukan "aplikasi", ganti importnya.
import 'package:aplikasi/models/tugas.dart';
import 'package:aplikasi/models/tugas_factory.dart';
import 'package:aplikasi/models/tugas_kuliah.dart';
import 'package:aplikasi/models/tugas_organisasi.dart';
import 'package:aplikasi/utils/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DateTime hariDepan(int n) => DateTime.now().add(Duration(days: n));

  group('Polymorphism hitungPrioritas', () {
    test('deadline 2 hari: kuliah tinggi, organisasi sedang', () {
      final kuliah = TugasKuliah(
        judul: 'Laporan',
        deadline: hariDepan(2),
        estimasiJam: 1,
        mataKuliah: 'Pemrograman Mobile',
      );
      final organisasi = TugasOrganisasi(
        judul: 'Proposal',
        deadline: hariDepan(2),
        estimasiJam: 1,
        namaOrganisasi: 'BEM',
      );
      expect(kuliah.hitungPrioritas(), Prioritas.tinggi);
      expect(organisasi.hitungPrioritas(), Prioritas.sedang);
    });

    test('tugas selesai selalu prioritas rendah', () {
      final kuliah = TugasKuliah(
        judul: 'Laporan',
        deadline: hariDepan(0),
        estimasiJam: 1,
        selesai: true,
        mataKuliah: 'PBO',
      );
      expect(kuliah.hitungPrioritas(), Prioritas.rendah);
    });

    test('tugas kuliah dengan estimasi lama menjadi sedang', () {
      final kuliah = TugasKuliah(
        judul: 'Proyek',
        deadline: hariDepan(10),
        estimasiJam: 9,
        mataKuliah: 'PBO',
      );
      expect(kuliah.hitungPrioritas(), Prioritas.sedang);
    });
  });

  group('toMap / tugasDariMap', () {
    test('TugasKuliah bolak-balik lewat Map', () {
      final asli = TugasKuliah(
        id: 7,
        judul: 'Laporan',
        deskripsi: 'Bab 1-3',
        deadline: DateTime(2026, 11, 5),
        estimasiJam: 4,
        mataKuliah: 'Pemrograman Mobile',
        emailDosen: 'dosen@kampus.ac.id',
      );
      final hasil = tugasDariMap(asli.toMap());
      expect(hasil, isA<TugasKuliah>());
      expect(hasil.id, 7);
      expect(hasil.judul, 'Laporan');
      expect(hasil.deadline, DateTime(2026, 11, 5));
      expect((hasil as TugasKuliah).emailDosen, 'dosen@kampus.ac.id');
    });

    test('TugasOrganisasi bolak-balik lewat Map', () {
      final asli = TugasOrganisasi(
        judul: 'Rapat',
        deadline: DateTime(2026, 11, 5),
        estimasiJam: 2,
        namaOrganisasi: 'HIMA',
      );
      final hasil = tugasDariMap(asli.toMap());
      expect(hasil, isA<TugasOrganisasi>());
      expect((hasil as TugasOrganisasi).namaOrganisasi, 'HIMA');
    });

    test('copyWith mengubah status selesai dan mempertahankan tipe', () {
      final asli = TugasKuliah(
        judul: 'Laporan',
        deadline: DateTime(2026, 11, 5),
        estimasiJam: 4,
        mataKuliah: 'PBO',
      );
      final salinan = asli.copyWith(selesai: true);
      expect(salinan, isA<TugasKuliah>());
      expect(salinan.selesai, isTrue);
      expect(asli.selesai, isFalse);
    });
  });

  group('Validator', () {
    test('wajib', () {
      expect(Validator.wajib('', 'Judul'), isNotNull);
      expect(Validator.wajib('  ', 'Judul'), isNotNull);
      expect(Validator.wajib('abc', 'Judul'), isNull);
    });

    test('minPanjang', () {
      expect(Validator.minPanjang('ab', 3, 'Judul'), isNotNull);
      expect(Validator.minPanjang('abc', 3, 'Judul'), isNull);
    });

    test('angkaRentang', () {
      expect(Validator.angkaRentang('x', min: 1, max: 100, nama: 'Jam'), isNotNull);
      expect(Validator.angkaRentang('0', min: 1, max: 100, nama: 'Jam'), isNotNull);
      expect(Validator.angkaRentang('101', min: 1, max: 100, nama: 'Jam'), isNotNull);
      expect(Validator.angkaRentang('5', min: 1, max: 100, nama: 'Jam'), isNull);
    });

    test('emailOpsional', () {
      expect(Validator.emailOpsional(''), isNull);
      expect(Validator.emailOpsional('salah'), isNotNull);
      expect(Validator.emailOpsional('a@b'), isNotNull);
      expect(Validator.emailOpsional('dosen@kampus.ac.id'), isNull);
    });
  });
}
