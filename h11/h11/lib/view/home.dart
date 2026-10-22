import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../viewmodel/tasbih_controller.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final TasbihController controller = Get.put(TasbihController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 119, 210, 145),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.resetCounter,
        tooltip: 'Reset hitungan',
        backgroundColor: Colors.white,
        child: const Icon(Icons.refresh_outlined, color: Colors.black),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(
                  () => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '${controller.counter.value.round()}',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 250),
                    ),
                  ),
                ),
                Obx(
                  () => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: LinearProgressIndicator(
                      value: controller.progress.value / 100,
                      backgroundColor: Colors.white54,
                      color: Colors.amberAccent.shade400,
                      minHeight: 15,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 75),
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                  child: Material(
                    color: Colors.white,
                    child: InkWell(
                      onTap: controller.incrementCounter,
                      child: const Padding(
                        padding: EdgeInsets.all(30),
                        child: Icon(Icons.fingerprint, size: 100),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
