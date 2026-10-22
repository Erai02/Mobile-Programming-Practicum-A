import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tasbih_getx/main.dart';
import 'package:tasbih_getx/viewmodel/tasbih_controller.dart';

void main() {
  tearDown(() => Get.reset());

  test('Reset dari batas maksimum dan reset berulang tetap nol', () {
    final controller = TasbihController();
    for (var i = 0; i < 40; i++) {
      controller.incrementCounter();
    }
    controller.resetCounter();
    controller.resetCounter();
    expect(controller.counter.value, 0);
    expect(controller.progress.value, 0);
    controller.incrementCounter();
    expect(controller.counter.value, 1);
  });

  testWidgets('UI berhenti di 33 dan progress penuh', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    for (var i = 0; i < 35; i++) {
      await tester.tap(find.byIcon(Icons.fingerprint));
      await tester.pump();
    }
    expect(find.text('33'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1,
    );
    expect(tester.takeException(), isNull);
    await tester.tap(find.byIcon(Icons.refresh_outlined));
    await tester.pump();
    expect(find.text('0'), findsOneWidget);
  });

  testWidgets('Layar pendek tidak menyebabkan overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const MyApp());
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.byIcon(Icons.fingerprint));
    await tester.tap(find.byIcon(Icons.fingerprint));
    await tester.pump();
    expect(Get.find<TasbihController>().counter.value, 1);
    expect(tester.takeException(), isNull);
  });
}
