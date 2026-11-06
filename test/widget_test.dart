import 'package:flutter_test/flutter_test.dart';
import 'package:pm_p7_4243250017/main.dart';

void main() {
  testWidgets('Uji aplikasi MePlan berhasil dimuat', (tester) async {
    await tester.pumpWidget(const MePlanApp());
    expect(find.text('MePlan — Daftar Tugas'), findsOneWidget);
  });
}