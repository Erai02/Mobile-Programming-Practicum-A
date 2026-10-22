import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tasbih_getx/main.dart';

void main() {
  tearDown(() => Get.reset());

  testWidgets('Fingerprint menambah hitungan dan reset mengosongkan progress', (
    tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('0'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
    await tester.tap(find.byIcon(Icons.fingerprint));
    await tester.pump();
    expect(find.text('1'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      closeTo(1 / 33, 0.000001),
    );
    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0,
    );
  });
}
