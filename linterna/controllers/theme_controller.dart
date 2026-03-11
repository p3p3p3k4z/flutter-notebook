//import 'package:light/light.dart';

import '../services/light_service.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  //
  final LightService _lightService = LightService();

  ThemeMode _thememode = ThemeMode.light;

  //getter
  ThemeMode get thememode => _thememode;

  void startListening() {
    // leer el stream
    _lightService.lightStream.listen((lux) {
      if (lux > 50) {
        _thememode = ThemeMode.light;
      } else {
        _thememode = ThemeMode.dark;
      }
    });

    // los que escuchan serán notificados
    notifyListeners();
  }
}
