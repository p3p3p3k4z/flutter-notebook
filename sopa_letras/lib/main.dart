import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(const WordSearchApp());

class WordSearchApp extends StatelessWidget {
  const WordSearchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
