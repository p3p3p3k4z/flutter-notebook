# Clase 2: Datos y Listas

En esta sesión aprendimos a conectar información (una lista de mapas) con la interfaz visual, usando widgets que permiten que el contenido sea dinámico y flexible.
## 🖼️ Manejo de Imágenes y Contenedores

### 1. Container (El contenedor versátil)

- **Analogía:** Una **caja de regalo**. Puedes decidir el tamaño de la caja, ponerle un color de fondo, darle un margen para que no toque a otras cajas y, finalmente, meter un regalo (un hijo) adentro.
    
- **Función:** Widget que combina propiedades de posicionamiento, tamaño (ancho/alto) y decoración (márgenes, color, bordes).
    
- **Uso común:** Para dar dimensiones específicas a un widget que no las tiene o para separar elementos usando márgenes.
    

```Dart
Container(
  margin: EdgeInsets.all(10.0), // Espacio por fuera de la caja
  width: 100.0,                // Ancho fijo
  child: Image.network(
    "https://url-de-tu-imagen.jpg", // Trae una imagen de internet
  ),
)
```

---

## 📐 Widgets de Control de Espacio

### 1. Expanded (El "Resorte" o "Globo")

- **Analogía:** Imagina que tienes una caja de cartón (la `Column`) con un libro arriba (un `Container`). Si metes un **globo** debajo y lo inflas, este se expandirá hasta tocar el fondo y los lados de la caja, ocupando **todo el espacio que sobraba**. El `Expanded` es ese globo.
    
- **Función:** Obliga a un hijo de una `Column` o `Row` a expandirse para llenar todo el espacio vacío disponible en el eje principal.
    
- **Uso común:** Se usa casi siempre cuando metes un `ListView` dentro de una `Column`. Como la lista es "infinita", la columna se confunde y no sabe qué tamaño darle; el `Expanded` le dice a la lista: "Toma exactamente el espacio que sobra aquí abajo".

```Dart
Expanded(
  child: ListView.builder(
    itemCount: comida.length,
    itemBuilder: (context, index) {
      // El ListView se estira gracias al Expanded
      return ListTile( ... );
    },
  ),
)
```
---

## 📋 Listas Dinámicas

### 3. ListView.builder (La fábrica eficiente)

- **Analogía:** Una **línea de ensamblaje inteligente**. En lugar de construir 1000 elementos a la vez (lo que trabaría el celular), esta "fábrica" solo construye los elementos que el usuario está viendo actualmente en pantalla.
    
- **Función:** Crea una lista de widgets de forma dinámica y bajo demanda.
    
- **Uso común:** Mostrar feeds de redes sociales, menús de comida o cualquier lista larga de datos que provenga de una base de datos.
    


```Dart
Expanded(
  child: ListView.builder(
    itemCount: comida.length, // ¿Cuántos elementos hay en total?
    itemBuilder: (context, index) {
      // Esta función se repite por cada elemento de la lista
      final elemento = comida[index];
      return ListTile(
        leading: Icon(elemento["Icono"]),
        title: Text(elemento["Nombre"]),
        trailing: Image.network(elemento["Imagen"], width: 90),
      );
    },
  ),
)
```

---

## 🗂️ Estructura de Datos: Listas y Mapas

Para que la aplicación sepa qué mostrar, usamos una **Lista de Mapas**.

- **List (`[]`)**: Una colección ordenada de elementos.
    
- **Map (`{}`)**: Un conjunto de pares "Clave: Valor" (como un diccionario).
    

```Dart
final List<Map<String, dynamic>> comida = [
  {
    "Nombre": "Tacos",
    "Icono": Icons.local_dining,
    "Imagen": "https://url-de-tacos.jpg",
  },
  // ... más elementos
];
```

---