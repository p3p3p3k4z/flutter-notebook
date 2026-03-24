import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Obtiene la instancia de la base de datos, inicializándola si es necesario.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('productos.db');
    return _database!;
  }

  /// Inicializa la conexión con la base de datos SQLite.
  /// Define la ruta donde se guardará el archivo .db.
  Future<Database> _initDB(String filePath) async {
    // Obtiene la ruta de la base de datos
    // getDatabasesPath() devuelve la ruta de la base de datos
    // la funcion getDatabasesPath() está incluida en el paquete sqflite
    final dbPath = await getDatabasesPath();
    // Une la ruta de la base de datos con el nombre del archivo
    // join() devuelve la ruta de la base de datos
    // la funcion join() está incluida en el paquete path
    final path = join(dbPath, filePath);
    // Abre la base de datos
    // openDatabase() devuelve la base de datos
    // la funcion openDatabase() está incluida en el paquete sqflite
    // la funcion openDatabase() es asincrona por lo que se debe usar await
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  //Crea
  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE productos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descripcion TEXT NOT NULL,
        nombre_corto TEXT NOT NULL,
        precio REAL NOT NULL,
        cantidad INTEGER NOT NULL
      )
    ''');
    // Insertar productos iniciales
    final List<Map<String, dynamic>> initialProducts = [
      {
        'descripcion': 'Ratón Óptico USB',
        'nombre_corto': 'Ratón',
        'precio': 15.50,
        'cantidad': 50,
      },
      {
        'descripcion': 'Teclado Mecánico RGB',
        'nombre_corto': 'Teclado',
        'precio': 45.00,
        'cantidad': 30,
      },
      {
        'descripcion': 'Monitor 24" LED Full HD',
        'nombre_corto': 'Monitor',
        'precio': 120.99,
        'cantidad': 15,
      },
      {
        'descripcion': 'Auriculares Gamer Pro',
        'nombre_corto': 'Auriculares',
        'precio': 35.75,
        'cantidad': 25,
      },
      {
        'descripcion': 'Alfombrilla XXL Gamer',
        'nombre_corto': 'Alfombrilla',
        'precio': 12.00,
        'cantidad': 40,
      },
    ];

    for (var product in initialProducts) {
      await db.insert('productos', product);
    }
  }

  /// Inserta un nuevo producto en la tabla.
  /// [producto] debe ser un mapa con las llaves correspondientes a las columnas.
  Future<int> insert(Map<String, dynamic> producto) async {
    final db = await instance.database;
    return await db.insert('productos', producto);
  }

  /// Recupera todos los productos de la tabla.
  Future<List<Map<String, dynamic>>> getAll() async {
    final db = await instance.database;
    return await db.query('productos');
  }

  /// Recupera un producto específico por su ID.
  Future<Map<String, dynamic>?> getById(int id) async {
    final db = await instance.database;
    final results = await db.query(
      'productos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return results.isNotEmpty ? results.first : null;
  }

  /// Actualiza los datos de un producto existente.
  Future<int> update(Map<String, dynamic> producto) async {
    final db = await instance.database;
    return await db.update(
      'productos',
      producto,
      where: 'id = ?',
      whereArgs: [producto['id']],
    );
  }

  /// Elimina un producto de la tabla por su ID.
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('productos', where: 'id = ?', whereArgs: [id]);
  }

  /// Cierra la conexión con la base de datos.
  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
