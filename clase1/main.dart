import 'package:flutter/material.dart';

void main() {
  // El punto de entrada donde inicia toda la aplicación de Flutter.
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aprendiendo Flutter',
      // Quitamos la etiqueta de "Debug" para que se vea más limpia la interfaz.
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orangeAccent),
        useMaterial3: true,
      ),
      // MyHomePage es nuestra pantalla principal.
      home: MyHomePage(title: 'Guía de Widgets'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // 1. SCAFFOLD: Es la estructura o "esqueleto" básico de Material Design.
    // Te da las bases para poner el AppBar, el cuerpo (body) y botones flotantes.
    return Scaffold(
      
      // 2. APPBAR: Es la barra superior de herramientas.
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.orangeAccent,
      ),

      // 3. CENTER: Este widget toma a su hijo y lo centra perfectamente 
      // tanto horizontal como verticalmente respecto a su padre (el Scaffold).
      body: Center(
        
        // 4. COLUMN: Organiza a sus hijos uno debajo del otro (verticalmente).
        child: Column(
          // mainAxisAlignment.center hace que los hijos se agrupen en el centro vertical de la columna.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            // TEXT: Widget diseñado para mostrar una línea de texto con estilo.
            Text(
              'Ejemplo de Stack debajo:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            // Usamos un Container para dar un pequeño margen o espacio.
            Container(height: 20),

            // 5. STACK: Permite colocar widgets uno sobre otro (encimados).
            // A diferencia de la columna, aquí los widgets "flotan" uno sobre otro.
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                
                // El primer widget del Stack es el que queda al fondo.
                // CONTAINER: Un widget común para dar tamaño, color y padding.
                Container(
                  width: 200,
                  height: 200,
                  color: Colors.blue[100],
                ),

                // Este segundo container se dibuja ENCIMA del anterior.
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.blue[400],
                ),

                // El último widget de la lista es el que queda hasta arriba de todos.
                Text(
                  '¡Estoy arriba!',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),

      // FLOATING ACTION BUTTON: El botón circular que flota en la esquina.
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí iría la acción al presionar.
        },
        // ICON: Muestra un icono de la librería de Material.
        child: Icon(Icons.star),
      ),
    );
  }
}
