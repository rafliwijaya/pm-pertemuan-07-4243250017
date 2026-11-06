import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'halaman_daftar_tugas.dart';
import 'halaman_form_tambah.dart';
import 'halaman_statistik.dart';
import 'tugas_model.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TugasModel(),
      child: const MePlanApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => KerangkaNavigasi(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const HalamanDaftarTugas(),
              routes: [
                GoRoute(
                  path: 'tambah',
                  builder: (context, state) => const HalamanFormTambah(),
                ),
              ],
            ),
          ],
        ),

        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/statistik',
              builder: (context, state) => const HalamanStatistik(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class MePlanApp extends StatelessWidget {
  const MePlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MePlan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2E66E7),
          brightness: Brightness.light,
        ),
      ),
      routerConfig: _router,
    );
  }
}

class KerangkaNavigasi extends StatelessWidget {
  const KerangkaNavigasi({super.key, required this.shell});

  final StatefulNavigationShell shell;

  void _pilih(int index) {
    shell.goBranch(index, initialLocation: index == shell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final lebarLayar = MediaQuery.sizeOf(context).width;
    final tugasAktif =
        context.select((TugasModel m) => m.jumlahAktif);

    final ikonDaftar = Badge.count(
      count: tugasAktif,
      isLabelVisible: tugasAktif > 0,
      child: const Icon(Icons.check_box_outlined),
    );
    if (lebarLayar >= 840) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: shell.currentIndex,
              onDestinationSelected: _pilih,
              labelType: NavigationRailLabelType.all,
              leading: const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Icon(Icons.edit_calendar, size: 36, color: Color(0xFF2E66E7)),
              ),
              destinations: [
                NavigationRailDestination(
                  icon: ikonDaftar,
                  selectedIcon: Badge.count(
                    count: tugasAktif,
                    isLabelVisible: tugasAktif > 0,
                    child: const Icon(Icons.check_box),
                  ),
                  label: const Text('Tugas'),
                ),
                const NavigationRailDestination(
                  icon: Icon(Icons.bar_chart_outlined),
                  selectedIcon: Icon(Icons.bar_chart),
                  label: Text('Statistik'),
                ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: shell),
          ],
        ),
      );
    }
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _pilih,
        destinations: [
          NavigationDestination(
            icon: ikonDaftar,
            selectedIcon: Badge.count(
              count: tugasAktif,
              isLabelVisible: tugasAktif > 0,
              child: const Icon(Icons.check_box),
            ),
            label: 'Tugas',
          ),
          const NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
        ],
      ),
    );
  }
}