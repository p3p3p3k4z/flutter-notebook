El **Estado** es la información que el widget "recuerda" mientras la aplicación está abierta. Si algo en la pantalla cambia (un color, un texto, un número), es porque hubo un cambio de estado.

---

## 🖼️ 1. StatelessWidget (El widget "Sin Memoria")

- **Analogía:** Una **fotografía impresa**. Una vez que sale de la impresora, no puedes cambiar lo que hay dentro. Si quieres que la foto sea distinta, tienes que destruirla y "tomar" una nueva.
    
- **Función:** Solo muestra información. Recibe datos al nacer y se queda con ellos hasta que el widget desaparece.
    
- **Cuándo usarlo:** Para cosas que no cambian por interacción del usuario, como un título, un logo o el nombre de un platillo en un menú.
    

```Dart
class NombreComida extends StatelessWidget {
  // El dato entra aquí, pero es "final" (no cambia)
  final String nombre;

  NombreComida(this.nombre);

  @override
  Widget build(BuildContext context) {
    return Text(nombre); // Solo muestra el texto que le dieron
  }
}
```

---

## ⚡ 2. StatefulWidget (El widget "Con Memoria")

- **Analogía:** Una **pizarra digital**. Puedes escribir en ella y, si te equivocas o quieres cambiar algo, simplemente borras y vuelves a escribir sin tirar la pizarra a la basura.
    
- **Función:** Puede cambiar su apariencia mientras el usuario lo está viendo. Tiene un motor llamado `setState()` que le avisa a Flutter: _"¡Oye! Algo cambió en mi memoria, vuelve a dibujarme"_.
    
- **Cuándo usarlo:** Cuando el usuario interactúa (hace click, escribe, desliza) y la pantalla debe reaccionar.
    

```Dart
class ContadorTacos extends StatefulWidget {
  @override
  State<ContadorTacos> createState() => _ContadorTacosState();
}

class _ContadorTacosState extends State<ContadorTacos> {
  // Esta es la "Memoria" (Estado)
  int cantidad = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Tacos pedidos: " + cantidad.toString()),
        ElevatedButton(
          onPressed: () {
            // setState es el botón de "Actualizar" de la pizarra
            setState(() {
              cantidad = cantidad + 1; 
            });
          },
          child: Text("Pedir otro taco"),
        ),
      ],
    );
  }
}
```

---

## ⚖️ ¿Cuándo elegir uno u otro?

|**¿El widget debe...**|**...usar StatelessWidget?**|**...usar StatefulWidget?**|
|---|---|---|
|¿Solo mostrar un texto o imagen?|✅ SÍ|❌ No|
|¿Cambiar de color al tocarlo?|❌ No|✅ SÍ|
|¿Aumentar un número?|❌ No|✅ SÍ|
|¿Ahorrar batería y memoria?|✅ SÍ (es más ligero)|❌ No (es más pesado)|

---

### 💡 Resumen para no olvidar:

1. **Stateless:** Es una **estatua**. Es bonita, pero no se mueve. Si quieres que se mueva, tienes que poner otra estatua en su lugar.
    
2. **Stateful:** Es un **actor**. El actor puede cambiarse de ropa, moverse y hablar mientras tú lo estás viendo en el escenario.
    
3. **setState:** Es la clave. Sin esta función, aunque cambies la variable en el código, la pantalla no se enterará y seguirá mostrando el dato viejo.
    
