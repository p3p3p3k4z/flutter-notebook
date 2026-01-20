# Formularios e Interacción

En esta sesión aprendimos a recibir información del usuario y a detectar gestos táctiles en elementos que normalmente no son botones.

---

## ⌨️ Entrada de Datos

### 1. TextEditingController (El "Secretario")

- **Analogía:** Un **secretario con una libreta**. Su único trabajo es estar sentado junto al campo de texto y anotar cada letra que el usuario escribe para que tú puedas preguntarle después: "¿Qué anotaste?".
    
- **Función:** Controla y manipula el texto de un campo de entrada. Permite leer el valor o borrarlo desde el código.
    
- **Uso común:** Se vincula a un `TextField` para obtener lo que la persona escribió.
    

```Dart
// Creación del controlador (Se pone al inicio del State)
final TextEditingController nombreController = TextEditingController();

// Uso para extraer el dato
String dato = nombreController.text; 
```

### 2. TextField (El "Cuadro de Texto")

- **Analogía:** Un **renglón en blanco** en un formulario de papel.
    
- **Función:** Es el widget visual donde el usuario hace clic para desplegar el teclado y escribir.
    
- **Uso común:** Recibir nombres, correos o números (usando `keyboardType`).
    

---

## 🖱️ Detección de Gestos

### 3. GestureDetector (El "Sensor de Movimiento")

- **Analogía:** Una **alarma invisible**. Puedes ponerla sobre cualquier objeto (una imagen, un texto o un cuadro de color) y, cuando alguien lo toca, la alarma se activa y ejecuta una acción.
    
- **Función:** Envuelve a cualquier widget para que responda a toques, doble clics o presión larga.
    
- **Uso común:** Convertir un `Container` o una `Image` en algo que funcione como un botón.
    


```Dart
GestureDetector(
  onTap: () {
    // Aquí pones lo que quieres que pase al hacer clic
    setState(() {
      mostrarImagen = true;
    });
  },
  child: Container(
    color: Colors.grey,
    child: Text('Haz clic aquí'),
  ),
)
```

---

## 🎨 Widgets de Diseño de Formularios

### 4. Padding (El "Espacio Personal")

- **Analogía:** El **distanciamiento social**. Evita que los widgets estén pegados a los bordes de la pantalla o entre ellos, dándoles un "colchón" de aire.
    
- **Función:** Añade espacio vacío alrededor de su widget hijo.
    


```Dart
Padding(
  padding: EdgeInsets.all(16.0), // Aplica 16 pixeles de margen interno en todos los lados
  child: Column( ... ),
)
```

---

## 🛠️ Metodología de Envío (Lógica)

Para procesar el formulario, usamos una función que une la información de los "secretarios" (controladores) y actualiza la pantalla:

Dart

```
void enviarFormulario() {
  setState(() {
    // Unimos los textos de dos controladores en una sola variable
    nombreCompleto = '${nombreController.text} ${apellidoController.text}';
  });
}
```

### 💡 Tips para tu repositorio:

- **Divider():** Es el widget que dibuja esa línea delgada horizontal para separar secciones (como la que usamos entre el formulario y el resultado).
    
- **SizedBox(height: 10):** La forma más limpia de separar dos `TextField` verticalmente sin usar márgenes complejos.
    