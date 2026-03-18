// services/light_service.dart

import 'package:light/light.dart';

class LightService {
  final Light _light = Light();

  Stream<int> get lightStream {
    return _light.lightSensorStream; // Proporciona un flujo continuo de datos asíncronos medidos en lux.
  }
}
