import 'package:get/get.dart';

/// Logika dan state reaktif tasbih, terpisah dari tampilan.
class TasbihController extends GetxController {
  final counter = 0.0.obs;
  final progress = 0.0.obs;
  final double maxCount = 33;

  void resetCounter() {
    counter.value = 0;
    progress.value = 0;
  }

  void incrementCounter() {
    if (counter.value < maxCount) {
      counter.value++;
      progress.value = (counter.value / maxCount) * 100;
    }
  }
}
