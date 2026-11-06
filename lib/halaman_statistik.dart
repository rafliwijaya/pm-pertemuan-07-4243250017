import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'tugas_model.dart';

class HalamanStatistik extends StatelessWidget {
  const HalamanStatistik({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<TugasModel>();
    final skema = Theme.of(context).colorScheme;
    final persentase = (model.persentaseSelesai * 100).toStringAsFixed(1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Belajar'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: skema.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Pencapaian Tugas',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: skema.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 100,
                    width: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: model.persentaseSelesai,
                          strokeWidth: 10,
                          backgroundColor:
                              skema.primary.withValues(alpha: 0.2),
                          valueColor:
                              AlwaysStoppedAnimation<Color>(skema.primary),
                        ),
                        Center(
                          child: Text(
                            '$persentase%',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: skema.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '${model.jumlahSelesai} dari ${model.jumlahTotal} tugas telah diselesaikan',
                    style: TextStyle(
                      fontSize: 14,
                      color: skema.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Total Tugas',
                  value: '${model.jumlahTotal}',
                  icon: Icons.list_alt,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Perlu Dikerjakan',
                  value: '${model.jumlahAktif}',
                  icon: Icons.pending_actions,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Selesai',
                  value: '${model.jumlahSelesai}',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Tips Produktivitas'),
            subtitle: Text(
                'Prioritaskan tugas dengan batas waktu terdekat agar tidak menumpuk menjelang evaluasi akhir.'),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}