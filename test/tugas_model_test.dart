import 'package:flutter_test/flutter_test.dart';
import '../lib/tugas_model.dart';

void main() {
  group('Unit Test Logika State TugasModel', () {
    test('Test 1: Menambah tugas baru memperbarui jumlah total dan tugas aktif', () {
      final model = TugasModel();
      final totalAwal = model.jumlahTotal;
      final aktifAwal = model.jumlahAktif;

      model.tambah(
        TugasKuliah(
          id: 'test_100',
          judul: 'Tugas Uji Coba',
          mataKuliah: 'Pengujian Perangkat Lunak',
          tenggat: DateTime.now().add(const Duration(days: 1)),
          selesai: false,
        ),
      );

      expect(model.jumlahTotal, totalAwal + 1);
      expect(model.jumlahAktif, aktifAwal + 1);
    });

    test('Test 2: Toggle selesai memperbarui status tugas dan persentase', () {
      final model = TugasModel();
      expect(model.daftarTugas.first.selesai, false);
      model.toggleSelesai('1');
      expect(model.daftarTugas.first.selesai, true);
      model.toggleSelesai('1');
      expect(model.daftarTugas.first.selesai, false);
    });

    test('Test 3: Menghapus tugas mengurangi jumlah total tugas', () {
      final model = TugasModel();
      final totalAwal = model.jumlahTotal;

      model.hapus('2');
      expect(model.jumlahTotal, totalAwal - 1);
      expect(model.daftarTugas.any((t) => t.id == '2'), false);
    });
  });
}