import 'package:flutter/material.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String display = '';
  double? firstNumber;
  String? operator;

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
        display = '';
        firstNumber = null;
        operator = null;
      } else if (value == '+' || value == '-' || value == '*') {
        firstNumber = double.parse(display);
        operator = value;
        display = '';
      } else if (value == '=') {
        double secondNumber = double.parse(display.isEmpty ? '0' : display);
        double result = 0;

        switch (operator) {
          case '+':
            result = firstNumber! + secondNumber;
            break;
          case '-':
            result = firstNumber! - secondNumber;
            break;
          case '*':
            result = firstNumber! * secondNumber;
            break;
        }

        display = result.toString();
      } else {
        display += value;
      }
    });
  }

  Widget buildButton(String text) {
    return SizedBox(
      width: 60,
      height: 60,

      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ElevatedButton(
          onPressed: () => onButtonPressed(text),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 34, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget verticalLayout() {
    return Column(
      children: [
        buildDisplay(flex: 1),
        //SizedBox(height: 20),
        buildButtonsGrid(crossAxisCount: 3),
        //Container(height: 20, color: Colors.amber,),
      ],
    );
  }

  Widget horizontalLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildDisplay(flex: 2),
        //SizedBox(height: 20),
        buildButtonsGridH(crossAxisCount: 8),
        //Container(height: 20, color: Colors.amber,),
      ],
    );
  }

  Widget buildDisplay({required int flex}) {
    return Expanded(
      flex: flex,
      child: Container(
        color: const Color.fromARGB(255, 14, 14, 14),
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        alignment: Alignment.centerRight,
        child: Text(
          display.isEmpty ? '0' : display,
          style: const TextStyle(fontSize: 50, color: Colors.white),
        ),
      ),
    );
  }

  Widget buildButtonsGrid({required int crossAxisCount}) {
    return Expanded(
      flex: 5,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.all(20),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: [
          buildButton('7'),
          buildButton('8'),
          buildButton('9'),

          buildButton('4'),
          buildButton('5'),
          buildButton('6'),

          buildButton('1'),
          buildButton('2'),
          buildButton('3'),

          buildButton('+'),
          buildButton('0'),
          buildButton('-'),

          buildButton('*'),
          buildButton('C'),
          buildButton('='),
        ],
      ),
    );
  }

  Widget buildButtonsGridH({required int crossAxisCount}) {
    return Expanded(
      flex: 6,
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        padding: const EdgeInsets.all(8),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: [
          buildButton('5'),
          buildButton('6'),
          buildButton('7'),
          buildButton('8'),
          buildButton('9'),
          buildButton('+'),
          buildButton('-'),
          buildButton('C'),

          buildButton('0'),
          buildButton('1'),
          buildButton('2'),
          buildButton('3'),
          buildButton('4'),
          buildButton('*'),
          buildButton('/'),
          buildButton('='),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? verticalLayout()
              : horizontalLayout();
        },
      ),
    );
  }
}
