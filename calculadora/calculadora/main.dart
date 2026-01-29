// https://rustpad.io/#QcMkGx
// error lends
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
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 13, 32, 72),
        ),
      ),
      home: Calculadora(),
    );
  }
}

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});

  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  String display = '';
  double? operando; // poder poner nulos (valores)
  String? operacion; //  operaciones

  void onButtonPressed(String value) {
    //setState(() =>  {});
    setState(() {
      if (value == '1' ||
          value == '2' ||
          value == '3' ||
          value == '4' ||
          value == '5' ||
          value == '6' ||
          value == '7' ||
          value == '8' ||
          value == '9' ||
          value == '0') {
        display += value;
      } else if (value == 'C') {
        display = '';
      } else if (value == '+') {
        operando = double.parse(display);
        operacion = value;
        display = '';
      } else if (value == '=') {
        //display = (double.parse(display ? '' : '0') + operando ? null : 0)
        //.toString();
      }
    });
  }

  Widget boton(String text) {
    return ElevatedButton(
      onPressed: () => onButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 187, 209, 220),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget buildDisplay() {
    return Container(
      padding: EdgeInsets.all(15),
      // padding: EdgeInsets.symmetric(40,10),
      alignment: Alignment.bottomRight,
      child: Text(
        display.isEmpty ? '0' : display,
        style: TextStyle(fontSize: 50),
      ),
    );
  }

  Widget gridBotonesV({required int crosAxisCount}) {
    //le indicamos que simpre vamos a necesitar ese parametro
    return Expanded(
      flex: 6,
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount: crosAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          boton("7"),
          boton("8"),
          boton("9"),
          boton("+"),
          boton("4"),
          boton("5"),
          boton("6"),
          boton("-"),
          boton("1"),
          boton("2"),
          boton("3"),
          boton("*"),
          boton("0"),
          boton("C"),
          boton("="),
          boton("/"),
        ],
      ),
    );
  }

  Widget gridBotonesH({required int crosAxisCount}) {
    return Expanded(
      flex: 6,
      child: GridView.count(
        padding: EdgeInsets.all(5),
        crossAxisCount: crosAxisCount,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        children: [
          boton("1"),
          boton("2"),
          boton("3"),
          boton("4"),
          boton("5"),
          boton("6"),
          boton("7"),
          boton("8"),
          boton("9"),
          boton("0"),
          boton("+"),
          boton("-"),
          boton("*"),
          boton("/"),
          boton("C"),
          boton("="),
        ],
      ),
    );
  }

  // https://rustpad.io/#az7tLf
  Widget horizontalLayout() {
    return Column(children: [buildDisplay(), gridBotonesH(crosAxisCount: 8)]);
  }

  Widget verticalLayout() {
    return Column(children: [buildDisplay(), gridBotonesV(crosAxisCount: 4)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Calculadora")),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.landscape
              ? horizontalLayout()
              : verticalLayout();
        },
      ),
    );
  }
}
