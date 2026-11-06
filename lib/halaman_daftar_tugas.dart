import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

enum FilterStatus { semua, aktif, selesai }

class HalamanDaftarTugas extends StatefulWidget {
  const HalamanDaftarTugas({super.key});

  @override
  State<HalamanDaftarTugas> createState() => _HalamanDaftarTugasState();
}

class _HalamanDaftarTugasState extends State<HalamanDaftarTugas> {
  FilterStatus _filterAktif = FilterStatus.semua;

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TugasModel>();
    final skema = Theme.of(context).colorScheme;
    final daftarTerfilter = model.daftarTugas.where((tugas) {
      if (_filterAktif == FilterStatus.aktif) return !tugas.selesai;
      if (_filterAktif == FilterStatus.selesai) return tugas.selesai;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('MePlan — Daftar Tugas'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/tambah'),
        icon: const Icon(Icons.add),
        label: const Text('Tambah Tugas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: Text('Semua (${model.jumlahTotal})'),
                  selected: _filterAktif == FilterStatus.semua,
                  onSelected: (selected) {
                    if (selected) setState(() => _filterAktif = FilterStatus.semua);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text('Aktif (${model.jumlahAktif})'),
                  selected: _filterAktif == FilterStatus.aktif,
                  onSelected: (selected) {
                    if (selected) setState(() => _filterAktif = FilterStatus.aktif);
                  },
                ),
                const SizedBox(width: 8),
                FilterChip(
                  label: Text('Selesai (${model.jumlahSelesai})'),
                  selected: _filterAktif == FilterStatus.selesai,
                  onSelected: (selected) {
                    if (selected) setState(() => _filterAktif = FilterStatus.selesai);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // ui daftar tugas
          Expanded(
            child: daftarTerfilter.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt, size: 64, color: skema.outline),
                        const SizedBox(height: 12),
                        Text(
                          'Tidak ada tugas pada filter ini',
                          style: TextStyle(color: skema.outline),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80, top: 8),
                    itemCount: daftarTerfilter.length,
                    itemBuilder: (context, i) {
                      final tugas = daftarTerfilter[i];
                      final formatTgl =
                          DateFormat('dd MMM yyyy').format(tugas.tenggat);
                      final sudahLewat = tugas.tenggat.isBefore(DateTime.now()) &&
                          !tugas.selesai;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        elevation: 1,
                        child: ListTile(
                          leading: Checkbox(
                            value: tugas.selesai,
                            onChanged: (_) {
                              context
                                  .read<TugasModel>()
                                  .toggleSelesai(tugas.id);
                            },
                          ),
                          title: Text(
                            tugas.judul,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: tugas.selesai
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: tugas.selesai ? Colors.grey : null,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: skema.secondaryContainer,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tugas.mataKuliah,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: skema.onSecondaryContainer,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.calendar_today,
                                    size: 13,
                                    color: sudahLewat
                                        ? Colors.red
                                        : skema.outline,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    formatTgl,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: sudahLewat
                                          ? Colors.red
                                          : skema.outline,
                                      fontWeight: sudahLewat
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline,
                                color: Colors.redAccent),
                            onPressed: () {
                              context.read<TugasModel>().hapus(tugas.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Tugas "${tugas.judul}" dihapus'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}