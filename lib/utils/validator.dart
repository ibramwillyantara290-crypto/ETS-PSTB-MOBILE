/// Kumpulan fungsi validasi untuk `TextFormField`.
/// Mengembalikan pesan error, atau null jika input valid.
class Validator {
  Validator._();

  static String? wajib(String? nilai, String nama) {
    if (nilai == null || nilai.trim().isEmpty) return '$nama wajib diisi';
    return null;
  }

  static String? minPanjang(String? nilai, int minimal, String nama) {
    if ((nilai ?? '').trim().length < minimal) {
      return '$nama minimal $minimal karakter';
    }
    return null;
  }

  static String? maksPanjang(String? nilai, int maksimal, String nama) {
    if ((nilai ?? '').trim().length > maksimal) {
      return '$nama maksimal $maksimal karakter';
    }
    return null;
  }

  static String? angkaRentang(
    String? nilai, {
    required int min,
    required int max,
    required String nama,
  }) {
    final angka = int.tryParse((nilai ?? '').trim());
    if (angka == null) return '$nama harus berupa angka';
    if (angka < min || angka > max) return '$nama harus antara $min dan $max';
    return null;
  }

  /// Email bersifat opsional: kosong dianggap valid, tetapi jika diisi
  /// formatnya harus benar.
  static String? emailOpsional(String? nilai) {
    final teks = (nilai ?? '').trim();
    if (teks.isEmpty) return null;
    final pola = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');
    return pola.hasMatch(teks) ? null : 'Format email tidak valid';
  }
}
