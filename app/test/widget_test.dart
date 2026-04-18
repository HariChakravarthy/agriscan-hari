import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:agriscan/main.dart';

void main() {
  testWidgets('AgriScan app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgriScanApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
