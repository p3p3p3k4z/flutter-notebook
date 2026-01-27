import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState(); //realizar estados
}

class _CalculadoraState extends State<Calculadora> {
  // Variable para guardar lo que se muestra en pantalla
  String display = "0";
  double? operando;
  late String operadorActual;
  // Función para actualizar la pantalla al presionar un botón
  void presionarBoton(String valor) {
    setState(() {
      if (valor == 'C') {
        display = "0";
        operando = null;
        return;
      }

      if (display == "0") {
        display = valor;
      } else if (display.contains('+') ||
          display.contains('-') ||
          display.contains('x') ||
          display.contains('/')) {
        operando = double.parse(display);
        display = valor;
      } else {
        display += valor;
      }

      if (valor == '=') {
        double resultado = 0;
        switch (operadorActual) {
          case '+':
            resultado = operando! + double.parse(display);
            break;
          case '-':
            resultado = operando! - double.parse(display);
            break;
          case 'x':
            resultado = operando! * double.parse(display);
            break;
          case '/':
            resultado = operando! / double.parse(display);
            break;
        }
        display = resultado.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculadora ^^"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Column(
        children: [
          // Área de visualización del resultado
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomRight,
              padding: const EdgeInsets.all(24),
              child: Text(
                display,
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Panel de botones
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              // Usamos SizedBox o Container para dar altura
              height: 400,
              // MediaQuery.of(context) obtiene info del dispositivo (como el ancho)
              width: MediaQuery.of(context).size.width,
              child: GridView.count(
                crossAxisCount: 4, // 4 columnas
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: [
                  // Ejemplo de botones creados dinámicamente
                  for (var btn in [
                    '7',
                    '8',
                    '9',
                    '/',
                    '4',
                    '5',
                    '6',
                    'x',
                    '1',
                    '2',
                    '3',
                    '-',
                    'C',
                    '0',
                    '=',
                    '+',
                  ])
                    ElevatedButton(
                      onPressed: () => presionarBoton(btn),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(100, 200, 200, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: Text(btn, style: const TextStyle(fontSize: 30)),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() => display = "0"); // Botón para resetear
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text("Calculadora ^^")),
    body: Column(
      children: [
        // Mostramos el número (puedes usar una variable aquí más adelante)
        const Padding(
          padding: EdgeInsets.all(20.0),
          child: Text(
            "123",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ),

        // El contenedor de los botones
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ), // Corregido: symmetric en vez de all
          child: SizedBox(
            // Usamos SizedBox para definir el tamaño
            height: 300,
            width: MediaQuery.of(
              context,
            ).size.width, // Corregido: MediaQuery.of
            child: GridView.count(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                // Un botón de ejemplo corregido
                ElevatedButton(onPressed: () {}, child: const Text("1")),
                // Aquí podrías agregar más botones...
              ],
            ),
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      child: const Icon(Icons.play_circle_fill_rounded),
    ),
  );
}
