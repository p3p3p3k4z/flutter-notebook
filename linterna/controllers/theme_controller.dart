import '../services/light_service.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  final LightService _lightService = LightService();
  ThemeMode _thememode = ThemeMode.light; //tema a usar
  
  int _lux = 0;  //intseidad de luz para interfaz

  ThemeMode get thememode => _thememode;
  int get lux => _lux; 

  void startListening() {
    _lightService.lightStream.listen((valorCapturado) {
      // Actualizamos el valor y notificamos a la UI
      _lux = valorCapturado; 
      
      // Aplica la lógica de negocio para determinar el umbral de cambio de tema.
      if (valorCapturado > 50) {
        _thememode = ThemeMode.light;
      } else {
        _thememode = ThemeMode.dark;
      }
      
      notifyListeners(); // Dispara una señal de actualización a todos los widgets que dependen de este controlador.
    });
  }
}