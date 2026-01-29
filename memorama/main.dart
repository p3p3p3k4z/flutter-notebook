import 'package:flutter/material.dart';

import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  // ]);

  runApp(const MemoramaApp());
}

class MemoramaApp extends StatelessWidget {
  const MemoramaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memorama',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//        useMaterial3: true,
      ),
        home: GameScreen(),      
    );
  }
}
