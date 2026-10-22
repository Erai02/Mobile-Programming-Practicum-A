import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alignment',
      theme: ThemeData.light(),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
            Text(
              'Malang',
              style: TextStyle(fontSize: 35),
              ),
            Text(
              '25°',
              style: TextStyle(fontSize: 120),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                harian('Minggu', Icons.sunny, '33°'),
                harian('Senin', Icons.cloudy_snowing, '26°'),
                harian('Selasa', Icons.cloud, '20°'),
              ],
            )
            ],
          )
        ),
      ),
    );
  }
}

Container harian(String hari, IconData icon, String suhu){
  return Container(
    height: 105,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
            hari,
            style: TextStyle(fontSize: 24),
          ),
        Icon(icon, size: 25),
        Text(
            suhu,
            style: TextStyle(fontSize: 24),
          )
      ],
    ),
  );
}