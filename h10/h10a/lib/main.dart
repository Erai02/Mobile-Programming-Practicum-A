import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:h10a/view/home.dart';
import 'package:h10a/view/detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Game Store',
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
        '/detail': (context) {
          final gameId = ModalRoute.of(context)!.settings.arguments as int;
          return Detail(gameTerpilih: gameId);
        },
      },
    );
  }
}
