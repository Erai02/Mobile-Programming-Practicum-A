import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flexible',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Flexible'),
        ),
        body: const Center(
          child: Row(
            children: [
              Flexible(
                fit: FlexFit.tight, flex: 1, child: KotakBiruJempolKecil()),
              Flexible(
                fit: FlexFit.tight, flex: 3, child: KotakBiruJempolKecil()),
              Flexible(
                fit: FlexFit.loose, flex: 2, child: KotakBiruJempolKecil()),
            ],
          ),
        ),
      ),
    );
  }
}

class KotakBiruJempolKecil extends StatelessWidget {
  const KotakBiruJempolKecil({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: Colors.blue,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.thumb_up,
        color: Colors.white,
        size: 40,
      ),
    );
  }
}