import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Row and Column',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Row and Column'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  KotakIkon(
                    warnaKotak: Colors.blue,
                    icon: Icons.thumb_up,
                    warnaIcon: Colors.yellow,
                    label: "Like",
                  ),
                  SizedBox(width: 20),
                  KotakIkon(
                    warnaKotak: Colors.green,
                    icon: Icons.favorite,
                    warnaIcon: Colors.red,
                    label: "Love",
                  ),
                ]
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center, 
                children: [
                  KotakIkon(
                    warnaKotak: Colors.orange,
                    icon: Icons.star,
                    warnaIcon: Colors.blueAccent,
                    label: "Stars",
                    ),
                  SizedBox(width: 20),
                  KotakIkon(
                    warnaKotak: Colors.black,
                    icon: Icons.comment,
                    warnaIcon: Colors.white,
                    label: "Comment",
                  ),
                ]
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KotakIkon extends StatelessWidget {
  final Color warnaKotak;
  final IconData icon;
  final Color warnaIcon;
  final String label;

  const KotakIkon({
    super.key,
    required this.warnaKotak,
    required this.icon,
    required this.warnaIcon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: warnaKotak,
            border: Border.all(color: Colors.black, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: warnaIcon,
            size: 40,
          ),
        ),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        )
      ]
    );
  }
}

