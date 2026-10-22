import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo GridView.builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Demo GridView.builder'),
      
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // List untuk menyimpan data berita
  List dataBerita = [];

  @override
  void initState() {
    super.initState();
    _ambilData();
  }

  // Method request data API
  Future _ambilData() async {
    try {
      final response = await http.get(
        Uri.parse('https://jakpost.vercel.app/api/category/business/tech'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          dataBerita = data['posts'];
        });
      } else {
        throw Exception('Gagal load data');
      }
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: dataBerita.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(
                  dataBerita[index]['title'] ?? "Tidak ada judul",
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  dataBerita[index]['published_at'] ?? "Tidak ada data",
                  maxLines: 1,
                  style: const TextStyle(fontSize: 16),
                ),
                leading: Image.network(
                  dataBerita[index]['image'] ??
                      'http://cdn.pixabay.com/photo/2018/03/17/20/51/white-buildings-3235135__340.jpg',
                  fit: BoxFit.cover,
                  width: 100,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}