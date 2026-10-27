import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../models/tugas.dart';
import '../models/tugas_kuliah.dart';
import '../models/tugas_organisasi.dart';
import '../providers/tugas_provider.dart';
import '../utils/format_tanggal.dart';
import '../utils/validator.dart';

/// Form tambah / ubah tugas. Jika [tugas] diisi, form masuk mode ubah.
class FormPage extends StatefulWidget {
  const FormPage({super.key, this.tugas});

  final Tugas? tugas;

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _judulCtrl;
  late final TextEditingController _deskripsiCtrl;
  late final TextEditingController _estimasiCtrl;
  late final TextEditingController _mataKuliahCtrl;
  late final TextEditingController _emailDosenCtrl;
  late final TextEditingController _organisasiCtrl;

  late String _jenis;
  DateTime? _deadline;
  late bool _selesai;
  bool _menyimpan = false;

  bool get _modeUbah => widget.tugas != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tugas;
    _jenis = t?.jenis ?? JenisTugas.kuliah;
    _deadline = t?.deadline;
    _selesai = t?.selesai ?? false;
    _judulCtrl = TextEditingController(text: t?.judul ?? '');
    _deskripsiCtrl = TextEditingController(text: t?.deskripsi ?? '');
    _estimasiCtrl =
        TextEditingController(text: t == null ? '' : '${t.estimasiJam}');
    _mataKuliahCtrl =
        TextEditingController(text: t is TugasKuliah ? t.mataKuliah : '');
    _emailDosenCtrl =
        TextEditingController(text: t is TugasKuliah ? t.emailDosen : '');
    _organisasiCtrl = TextEditingController(
      text: t is TugasOrganisasi ? t.namaOrganisasi : '',
    );
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _deskripsiCtrl.dispose();
    _estimasiCtrl.dispose();
    _mataKuliahCtrl.dispose();
    _emailDosenCtrl.dispose();
    _organisasiCtrl.dispose();
    super.dispose();
  }

  InputDecoration _dekorasi(String label, IconData ikon, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(ikon),
      border: const OutlineInputBorder(),
    );
  }

  Tugas _susunTugas() {
    final id = widget.tugas?.id;
    final judul = _judulCtrl.text.trim();
    final deskripsi = _deskripsiCtrl.text.trim();
    final estimasi = int.parse(_estimasiCtrl.text.trim());
    final deadline = _deadline!;

    if (_jenis == JenisTugas.kuliah) {
      return TugasKuliah(
        id: id,
        judul: judul,
        deskripsi: deskripsi,
        deadline: deadline,
        estimasiJam: estimasi,
        selesai: _selesai,
        mataKuliah: _mataKuliahCtrl.text.trim(),
        emailDosen: _emailDosenCtrl.text.trim(),
      );
    }
    return TugasOrganisasi(
      id: id,
      judul: judul,
      deskripsi: deskripsi,
      deadline: deadline,
      estimasiJam: estimasi,
      selesai: _selesai,
      namaOrganisasi: _organisasiCtrl.text.trim(),
    );
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _menyimpan = true);

    final provider = context.read<TugasProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final warnaError = Theme.of(context).colorScheme.error;
    final tugas = _susunTugas();

    final berhasil =
        _modeUbah ? await provider.ubah(tugas) : await provider.tambah(tugas);
    if (!mounted) return;

    if (berhasil) {
      navigator.pop();
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              _modeUbah ? 'Perubahan disimpan' : 'Tugas ditambahkan',
            ),
          ),
        );
    } else {
      setState(() => _menyimpan = false);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            backgroundColor: warnaError,
            content: Text(provider.pesanAksi ?? 'Gagal menyimpan tugas'),
          ),
        );
    }
  }

  Future<void> _pilihTanggal(FormFieldState<DateTime> state) async {
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);
    final dipilih = await showDatePicker(
      context: context,
      initialDate: _deadline ?? hariIni,
      firstDate: _modeUbah ? DateTime(2020) : hariIni,
      lastDate: DateTime(2100),
    );
    if (dipilih == null || !mounted) return;
    setState(() => _deadline = dipilih);
    state.didChange(dipilih);
  }

  @override
  Widget build(BuildContext context) {
    final sekarang = DateTime.now();
    final hariIni = DateTime(sekarang.year, sekarang.month, sekarang.day);

    return Scaffold(
      appBar: AppBar(title: Text(_modeUbah ? 'Ubah tugas' : 'Tugas baru')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Input pilihan 1: Dropdown jenis tugas
                  DropdownButtonFormField<String>(
                    // ignore: deprecated_member_use
                    value: _jenis,
                    isExpanded: true,
                    decoration: _dekorasi('Jenis tugas', Icons.category_outlined),
                    items: const [
                      DropdownMenuItem(
                        value: JenisTugas.kuliah,
                        child: Text('Tugas kuliah'),
                      ),
                      DropdownMenuItem(
                        value: JenisTugas.organisasi,
                        child: Text('Tugas organisasi'),
                      ),
                    ],
                    validator: (v) => v == null ? 'Pilih jenis tugas' : null,
                    onChanged: (v) {
                      if (v != null) setState(() => _jenis = v);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _judulCtrl,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _dekorasi('Judul tugas', Icons.title),
                    validator: (v) =>
                        Validator.wajib(v, 'Judul') ??
                        Validator.minPanjang(v, 3, 'Judul'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _deskripsiCtrl,
                    keyboardType: TextInputType.multiline,
                    minLines: 2,
                    maxLines: 4,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: _dekorasi(
                      'Deskripsi (opsional)',
                      Icons.notes,
                      hint: 'Catatan singkat tentang tugas ini',
                    ),
                    validator: (v) => Validator.maksPanjang(v, 200, 'Deskripsi'),
                  ),
                  const SizedBox(height: 16),
                  if (_jenis == JenisTugas.kuliah) ...[
                    TextFormField(
                      controller: _mataKuliahCtrl,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          _dekorasi('Mata kuliah', Icons.menu_book_outlined),
                      validator: (v) =>
                          Validator.wajib(v, 'Mata kuliah') ??
                          Validator.minPanjang(v, 3, 'Mata kuliah'),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailDosenCtrl,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      decoration: _dekorasi(
                        'Email dosen (opsional)',
                        Icons.email_outlined,
                        hint: 'dosen@kampus.ac.id',
                      ),
                      validator: Validator.emailOpsional,
                    ),
                  ] else
                    TextFormField(
                      controller: _organisasiCtrl,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.words,
                      decoration:
                          _dekorasi('Nama organisasi', Icons.groups_outlined),
                      validator: (v) =>
                          Validator.wajib(v, 'Nama organisasi') ??
                          Validator.minPanjang(v, 2, 'Nama organisasi'),
                    ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _estimasiCtrl,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: _dekorasi(
                      'Estimasi pengerjaan (jam)',
                      Icons.timer_outlined,
                    ),
                    validator: (v) =>
                        Validator.wajib(v, 'Estimasi') ??
                        Validator.angkaRentang(
                          v,
                          min: 1,
                          max: 100,
                          nama: 'Estimasi',
                        ),
                  ),
                  const SizedBox(height: 16),
                  // Input pilihan 2: DatePicker untuk deadline
                  FormField<DateTime>(
                    initialValue: _deadline,
                    validator: (v) {
                      if (v == null) return 'Pilih tanggal deadline';
                      if (!_modeUbah && v.isBefore(hariIni)) {
                        return 'Deadline tidak boleh sebelum hari ini';
                      }
                      return null;
                    },
                    builder: (state) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(4),
                        onTap: () => _pilihTanggal(state),
                        child: InputDecorator(
                          decoration: _dekorasi('Deadline', Icons.event)
                              .copyWith(errorText: state.errorText),
                          child: Text(
                            state.value == null
                                ? 'Pilih tanggal'
                                : formatTanggal(state.value!),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                  // Input pilihan 3: Checkbox status selesai
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _selesai,
                    onChanged: (v) => setState(() => _selesai = v ?? false),
                    title: const Text('Tandai sudah selesai'),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _menyimpan ? null : _simpan,
                    icon: _menyimpan
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(
                      _menyimpan
                          ? 'Menyimpan...'
                          : (_modeUbah ? 'Simpan perubahan' : 'Simpan tugas'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
