
Flutter es un framework donde las interfaces se construyen mediante **Widgets**, que funcionan como piezas de lego.

- **HotReload**: La capacidad de ver cambios en la pantalla al instante sin reiniciar la app.
    
- **Main**: El punto de partida de todo el código.
    
- **Método Build**: Es la función que se ejecuta para "dibujar" el widget en la pantalla.
    

> "En esta primera sesión exploramos los widgets de posicionamiento y agrupamiento, que son los bloques fundamentales para construir cualquier interfaz en Flutter."

---

## 🏗️ Widgets Estructurales

### 1. Scaffold

- **Analogía**: El **esqueleto o armazón** de un edificio. Define dónde van las ventanas, las puertas y el techo.
    
- **Función**: Implementa la estructura visual básica de Material Design.
    
- **Uso común**: Se usa como la base de casi cualquier pantalla que crees en Flutter.
    

Dart

```
Scaffold(
  // La barra de herramientas superior
  appBar: AppBar(
    title: Text('Mi Aplicación'),
    backgroundColor: Colors.blue,
  ),
  // El área de contenido principal
  body: Center(
    child: Text('Hola Mundo'),
  ),
  // Un botón de acción circular que flota
  floatingActionButton: FloatingActionButton(
    onPressed: () {
      // Acción al hacer click
    },
    child: Icon(Icons.add),
  ),
)
```

### 2. Center

- **Analogía**: El **tiro al blanco**. No importa qué tan grande sea el tablero, el widget siempre estará justo en el medio.
    
- **Función**: Alinea a su único hijo en el centro exacto (horizontal y vertical) de su widget padre.
    
- **Uso común**: Centrar un cargador (spinner), un mensaje de error o una imagen de perfil.
    

Dart

```
Center(
  // Solo acepta UN hijo (child)
  child: Text('Estoy en el centro'),
)
```

---

## 🧱 Widgets Agrupadores (Múltiples hijos)

### 3. Column

- **Analogía**: Una **lista de tareas** escrita en una hoja o una columna de bloques de construcción.
    
- **Función**: Organiza a sus hijos uno debajo del otro de forma vertical.
    
- **Uso común**: Crear formularios, perfiles de usuario o listas de información que se leen de arriba hacia abajo.
    

Dart

```
Column(
  // Permite tener una LISTA de hijos (children)
  children: <Widget>[
    Text('Primer elemento arriba'),
    Text('Segundo elemento debajo'),
    // El widget Expanded hace que el hijo ocupe el espacio sobrante
    Expanded(
      child: FittedBox(
        child: FlutterLogo(),
      ),
    ),
  ],
)
```

### 4. Stack

- **Analogía**: Las **capas de Photoshop** o un montón de hojas de papel puestas una sobre otra en un escritorio.
    
- **Función**: Permite encimar widgets. El primer widget en el código queda al fondo y el último queda arriba de todos.
    
- **Uso común**: Poner texto sobre una imagen, añadir un punto rojo de notificación sobre un ícono o crear fondos decorativos.
    

Dart

```
Stack(
  // Los elementos se dibujan en orden: el primero abajo, el último arriba
  children: <Widget>[
    // Cuadro de fondo (Capa 1)
    Container(
      width: 150,
      height: 150,
      color: Colors.red,
    ),
    // Cuadro más pequeño encima (Capa 2)
    Container(
      width: 100,
      height: 100,
      color: Colors.green,
    ),
    // Texto hasta arriba (Capa 3)
    Text('Encima de todo'),
  ],
)
```

---

### 💡 Conceptos Clave para Repasar

1. **Child**: Propiedad para un solo widget hijo (ej. Center).
    
2. **Children**: Propiedad para una lista de varios widgets (ej. Column, Stack).
    
3. **Posicionamiento**: La diferencia entre `Column` y `Stack` es que la columna **suma** espacios hacia abajo, mientras que el stack **encima** los espacios en el mismo lugar.
    
