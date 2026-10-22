import 'package:flutter_test/flutter_test.dart';
import 'package:tasbih_getx/viewmodel/tasbih_controller.dart';

void main() {
  test('Counter dan progress dimulai dari nol', () {
    final controller = TasbihController();
    expect(controller.counter.value, 0);
    expect(controller.progress.value, 0);
    expect(controller.maxCount, 33);
  });

  test('Setiap increment menghitung persentase sampai batas 33', () {
    final controller = TasbihController();
    for (var count = 1; count <= 33; count++) {
      controller.incrementCounter();
      expect(controller.counter.value, count.toDouble());
      expect(controller.progress.value, closeTo(count / 33 * 100, 0.000001));
    }
    controller.incrementCounter();
    expect(controller.counter.value, 33);
    expect(controller.progress.value, 100);
  });
}
