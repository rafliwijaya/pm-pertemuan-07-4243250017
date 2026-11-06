import 'package:flutter/foundation.dart';

class TugasKuliah {
  TugasKuliah({
    required this.id,
    required this.judul,
    required this.mataKuliah,
    required this.tenggat,
    this.selesai = false,
  });

  final String id;
  final String judul;
  final String mataKuliah;
  final DateTime tenggat;
  bool selesai;
}

class TugasModel extends ChangeNotifier {
  final List<TugasKuliah> _daftarTugas = [
    TugasKuliah(
      id: '1',
      judul: 'Tugas Rutin 7 State Management',
      mataKuliah: 'Pemrograman Mobile',
      tenggat: DateTime.now().add(const Duration(days: 2)),
      selesai: false,
    ),
    TugasKuliah(
      id: '2',
      judul: 'Normalisasi Database & Query SQL',
      mataKuliah: 'Basis Data Lanjut',
      tenggat: DateTime.now().add(const Duration(days: 4)),
      selesai: true,
    ),
    TugasKuliah(
      id: '3',
      judul: 'Implementasi Algoritma A-Star',
      mataKuliah: 'Kecerdasan Buatan',
      tenggat: DateTime.now().add(const Duration(days: 6)),
      selesai: false,
    ),
    TugasKuliah(
      id: '4',
      judul: 'Diagram Use Case & Activity',
      mataKuliah: 'Rekayasa Perangkat Lunak',
      tenggat: DateTime.now().add(const Duration(days: 8)),
      selesai: false,
    ),
  ];

  List<TugasKuliah> get daftarTugas => List.unmodifiable(_daftarTugas);
  int get jumlahTotal => _daftarTugas.length;
  int get jumlahSelesai =>
      _daftarTugas.where((t) => t.selesai).length;
  int get jumlahAktif =>
      _daftarTugas.where((t) => !t.selesai).length;
  double get persentaseSelesai =>
      jumlahTotal == 0 ? 0.0 : (jumlahSelesai / jumlahTotal);

  // tambah tugas
  void tambah(TugasKuliah tugas) {
    _daftarTugas.insert(0, tugas);
    notifyListeners();
  }

  // tandai selesai
  void toggleSelesai(String id) {
    final index = _daftarTugas.indexWhere((t) => t.id == id);
    if (index != -1) {
      _daftarTugas[index].selesai = !_daftarTugas[index].selesai;
      notifyListeners();
    }
  }

  // hps tugas
  void hapus(String id) {
    _daftarTugas.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}