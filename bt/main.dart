// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bluetooth Scanner',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const BluetoothPage(),
    );
  }
}

class BluetoothPage extends StatefulWidget {
  const BluetoothPage({super.key});

  @override
  State<BluetoothPage> createState() => _BluetoothPageState();
}

class _BluetoothPageState extends State<BluetoothPage> {
  List<ScanResult> devices = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  Future<void> startScan() async {
    devices.clear();

    // Escuchar resultados
    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        devices = results;
      });
    });

    // Iniciar escaneo
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bluetooth Scanner')),
      body: devices.isEmpty
          ? const Center(child: Text('No se encontraron dispositivos'))
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final result = devices[index];
                final device = result.device;
                final rssi = result.rssi;
                final name = result.advertisementData.advName.isNotEmpty
                    ? result.advertisementData.advName
                    : device.platformName;

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.bluetooth,
                      color: rssi > -60
                          ? Colors.green
                          : rssi > -80
                          ? Colors.orange
                          : Colors.red,
                    ),

                    title: Text(
                      device.platformName.isNotEmpty
                          ? device.platformName
                          : name.isNotEmpty
                          ? name
                          : 'Dispositivo desconocido',
                    ),

                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(device.remoteId.toString()),
                        Text('RSSI: $rssi dBm'),
                      ],
                    ),

                    trailing: Text(
                      rssi > -60
                          ? 'Cerca'
                          : rssi > -80
                          ? 'Media'
                          : 'Lejos',
                    ),
                  ),
                );
              },
            ),

      // body: devices.isEmpty
      //     ? const Center(
      //         child: Text('No se encontraron dispositivos'),
      //       )
      //     : ListView.builder(
      //         itemCount: devices.length,
      //         itemBuilder: (context, index) {
      //           final device = devices[index].device;

      //           return ListTile(
      //             leading: const Icon(Icons.bluetooth),
      //             title: Text(
      //               device.platformName.isNotEmpty
      //                   ? device.platformName
      //                   : 'Dispositivo desconocido',
      //             ),
      //             subtitle: Text(device.remoteId.toString()),
      //           );
      //         },
      //       ),
      floatingActionButton: FloatingActionButton(
        onPressed: startScan,
        child: const Icon(Icons.search),
      ),
    );
  }
}
