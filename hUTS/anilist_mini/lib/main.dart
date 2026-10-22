import 'package:flutter/material.dart';

import 'pages/home_page.dart';

const appBackground = Color(0xFF10101C);
const appSurface = Color(0xFF1C1B2B);
const appPurple = Color(0xFF8B5CF6);
const appLavender = Color(0xFFB39BFF);
const appMuted = Color(0xFFA9A5BC);
const appGold = Color(0xFFF8C95C);

void main() => runApp(const AniListMiniApp());

class AniListMiniApp extends StatelessWidget {
  const AniListMiniApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = ColorScheme.fromSeed(
      seedColor: appPurple,
      brightness: Brightness.dark,
      surface: appSurface,
    );
    return MaterialApp(
      title: 'AniList Mini',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: scheme,
        scaffoldBackgroundColor: appBackground,
        appBarTheme: const AppBarTheme(
          backgroundColor: appBackground,
          foregroundColor: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: appSurface,
          hintStyle: const TextStyle(color: appMuted),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: appPurple),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}
