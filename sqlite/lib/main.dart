import 'package:db_app/sqlite_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: const ProductsPage(),
    );
  }
}

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<Map<String, dynamic>> _products = [];
  // esta cargando los datos de la DB?
  bool isLoading = true;
  //mostrar una ventana flotante para actualizar/ingresar un nuevo product
  bool _showForm = false;

  @override
  void initState() {
    super.initState();
    _refreshProducts(); // leer los datos de la BD al iniciar
  }

  void _refreshProducts() async {
    final data = await DatabaseHelper.instance.getAll();
    setState(() {
      _products.clear();
      _products.addAll(data);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BD de productos")),
      body: Stack(
        children: [
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final prod = _products[index];
                    return ListTile(title: Text(prod['descripcion']));
                  },
                ),
        ],
      ),
    );
  }
}
