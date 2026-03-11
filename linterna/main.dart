import 'package:flutter/material.dart';
import 'controllers/theme_controller.dart';
import 'ui/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeController controller = ThemeController();

  @override
  void initState() {
    super.initState();
    controller.startListening();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Ambient Light Theme',

          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),

          themeMode: controller.thememode,

          home: HomePage(),
          //home: HomePage(lux: controller.lux),
        );
      },
    );
  }
}
