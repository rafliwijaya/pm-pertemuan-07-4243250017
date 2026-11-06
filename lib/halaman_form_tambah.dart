import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

class HalamanFormTambah extends StatefulWidget {
  const HalamanFormTambah({super.key});

  @override
  State<HalamanFormTambah> createState() => _HalamanFormTambahState();
}

class _HalamanFormTambahState extends State<HalamanFormTambah> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _judulController;
  late final TextEditingController _matkulController;
  DateTime _tenggatTerpilih = DateTime.now().add(const Duration(days: 3));

  @override
  void initState() {
    super.initState();
    _judulController = TextEditingController();
    _matkulController = TextEditingController();
  }

  @override
  void dispose() {
    _judulController.dispose();
    _matkulController.dispose();
    super.dispose();
  }

  Future<void> _pilihTanggal(BuildContext context) async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tenggatTerpilih,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (hasil != null) {
      setState(() => _tenggatTerpilih = hasil);
    }
  }

  void _simpanTugas() {
    if (_formKey.currentState?.validate() ?? false) {
      final tugasBaru = TugasKuliah(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        judul: _judulController.text.trim(),
        mataKuliah: _matkulController.text.trim(),
        tenggat: _tenggatTerpilih,
        selesai: false,
      );
      context.read<TugasModel>().tambah(tugasBaru);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tugas berhasil ditambahkan!')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatTgl = DateFormat('EEEE, dd MMMM yyyy').format(_tenggatTerpilih);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Tugas Kuliah')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  hintText: 'Contoh: Laporan Bab 3, Presentasi Final',
                  prefixIcon: Icon(Icons.assignment_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Judul tugas wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _matkulController,
                decoration: const InputDecoration(
                  labelText: 'Mata Kuliah',
                  hintText: 'Contoh: Pemrograman Mobile, Basis Data',
                  prefixIcon: Icon(Icons.school_outlined),
                  border: OutlineInputBorder(),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Mata kuliah wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event),
                title: const Text('Batas Waktu (Tenggat):'),
                subtitle: Text(formatTgl,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: OutlinedButton(
                  onPressed: () => _pilihTanggal(context),
                  child: const Text('Ubah Tanggal'),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _simpanTugas,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan Tugas',
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}