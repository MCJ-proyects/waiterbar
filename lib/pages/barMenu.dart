// Importamos las librerías necesarias para el correcto funcionamiento del código.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:waiterbar/pages/pago.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;


// Creamos una clase llamada BarMenu que extiende de StatefulWidget.
class BarMenu extends StatefulWidget {
  // Definimos un atributo final de tipo String llamado result.
  final String result;

  // Constructor de la clase BarMenu que recibe un parámetro obligatorio result y opcional key.
  const BarMenu({required this.result, Key? key}) : super(key: key);

  // Sobrescribimos el método createState para devolver una instancia de la clase _BarMenuState.
  @override
  _BarMenuState createState() => _BarMenuState(result: result);
}

// Define la clase _BarMenuState que extiende de State y maneja el estado del widget BarMenu.
class _BarMenuState extends State<BarMenu> {

  // Definición de variables
  final String result; // Variable que almacena el resultado
  final CollectionReference bares = FirebaseFirestore.instance.collection('bares'); // Referencia a la colección 'bares' en Firestore
  List<dynamic>? tapas; // Lista de tapas
  List<dynamic>? bebidas; // Lista de bebidas
  List<dynamic>? postres; // Lista de postres
  num cuenta = 0; // Contador para llevar la cuenta del precio total
  List<int> tapasPedidas = []; // Lista para almacenar la cantidad de cada tapa pedida
  List<int> bebidasPedidas = []; // Lista para almacenar la cantidad de cada bebida pedida
  List<int> postresPedidos = []; // Lista para almacenar la cantidad de cada postre pedido
  List<Map<String, dynamic>> pedidos = []; // Lista para almacenar los pedidos realizados
  bool _isCamareroEnCamino = false;

  _BarMenuState({required this.result}); // Constructor de la clase _BarMenuState

  Future<void> loadBarData() async { // Función asíncrona para cargar los datos del bar desde Firestore
      var data = await bares.doc(result).get(); // Se obtienen los datos del documento correspondiente al bar seleccionado
      var datos = data.data() as Map<String, dynamic>; // Se almacenan los datos en un mapa

      setState(() {
        cuenta = 0; // Se inicializa la cuenta en cero
      });

      if (!(datos['tapas']?.isEmpty ?? true)) { // Si existen tapas en los datos obtenidos
        setState(() {
          tapas = datos['tapas']; // Se almacenan las tapas en la lista correspondiente
          tapasPedidas = List<int>.filled(tapas!.length, 0); // Se inicializa la lista de tapas pedidas con ceros
        });
      }

      if (!(datos['bebidas']?.isEmpty ?? true)) { // Si existen bebidas en los datos obtenidos
        setState(() {
          bebidas = datos['bebidas']; // Se almacenan las bebidas en la lista correspondiente
          bebidasPedidas = List<int>.filled(bebidas!.length, 0); // Se inicializa la lista de bebidas pedidas con ceros
        });
      }

      if (!(datos['postres']?.isEmpty ?? true)) { // Si existen postres en los datos obtenidos
        setState(() {
          postres = datos['postres']; // Se almacenan los postres en la lista correspondiente
          postresPedidos = List<int>.filled(postres!.length, 0); // Se inicializa la lista de postres pedidos con ceros
        });
      }
    }


  // Define la función "sumar" que toma un índice y un tipo de producto como argumentos
  void sumar(int index, String tipo) {
    
    var nombre; // Declara una variable llamada "nombre"
    num precio = 0; // Inicializa una variable "precio" con valor cero
    
    // Utiliza una estructura switch para determinar el tipo de producto y actualizar la lista de pedidos correspondiente
    switch (tipo) {

      case 'tapas':

        // Obtiene el nombre y el precio del producto en la lista de tapas usando el índice proporcionado
        nombre = tapas![index]['nombre'];
        precio = tapas![index]['precio'];

        // Si el producto ya está en la lista de pedidos, aumenta su cantidad en uno
        if (pedidos.any((item) => item['nombre'] == nombre)) {
          pedidos.firstWhere((item) => item['nombre'] == nombre)['cantidad']++;
        } else { // De lo contrario, agrega el producto a la lista de pedidos con una cantidad de uno
          pedidos.add({'nombre': nombre, 'cantidad': 1, 'precio': precio});
        }

        // Incrementa el contador de pedidos para este producto específico
        tapasPedidas[index]++;
        break;

      case 'bebidas':

        // Obtiene el nombre y el precio del producto en la lista de bebidas usando el índice proporcionado
        nombre = bebidas![index]['nombre'];
        precio = bebidas![index]['precio'];

        // Si el producto ya está en la lista de pedidos, aumenta su cantidad en uno
        if (pedidos.any((item) => item['nombre'] == nombre)) {
          pedidos.firstWhere((item) => item['nombre'] == nombre)['cantidad']++;
        } else { // De lo contrario, agrega el producto a la lista de pedidos con una cantidad de uno
          pedidos.add({'nombre': nombre, 'cantidad': 1, 'precio': precio});
        }

        // Incrementa el contador de pedidos para este producto específico
        bebidasPedidas[index]++;
        break;

      case 'postres':

        // Obtiene el nombre y el precio del producto en la lista de postres usando el índice proporcionado
        nombre = postres![index]['nombre'];
        precio = postres![index]['precio'];

        // Si el producto ya está en la lista de pedidos, aumenta su cantidad en uno
        if (pedidos.any((item) => item['nombre'] == nombre)) {
          pedidos.firstWhere((item) => item['nombre'] == nombre)['cantidad']++;
        } else { // De lo contrario, agrega el producto a la lista de pedidos con una cantidad de uno
          pedidos.add({'nombre': nombre, 'cantidad': 1, 'precio': precio});
        }

        // Incrementa el contador de pedidos para este producto específico
        postresPedidos[index]++;
        break;
    }
    
    // Actualiza el estado de la aplicación para reflejar el nuevo precio total de los pedidos
    setState(() {
      cuenta += precio;
    });
  }


  // Anula el método "initState" de la clase StatefulWidget actual
  @override
  void initState() {
    // Llama al método "initState" de la clase StatefulWidget padre
    super.initState();
    // Carga los datos de la barra
    loadBarData();
  }

// Define una función que construye una lista de elementos dinámicos y devuelve un widget
Widget _buildList(List<dynamic>? items, Function(int) onTap, String emptyMessage, String title) {
  // Si la lista de elementos está vacía, devuelve un ListTile con un mensaje vacío centrado
  if (items?.isEmpty ?? true) {
    return ListTile(
      title: Text(emptyMessage, textAlign: TextAlign.center),
    );
  }

  // De lo contrario, devuelve un ExpansionTile con el título especificado y una ListView.separated de los elementos
  return ExpansionTile(
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.black,
        fontStyle: FontStyle.italic,
        fontSize: 25,
      ),
    ),
    children: [
      ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: items!.length,
        itemBuilder: (context, index) {
          // Obtiene la referencia a la imagen del elemento en Firebase Storage
          final ref = firebase_storage.FirebaseStorage.instance.ref(items[index]['imagenItem']);

        return Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder(
                future: ref.getDownloadURL(),
                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      height: 225,
                      width: 175,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data!),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 55.0, horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        '${items[index]['nombre']} | ${items[index]['precio']}€',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        items[index]['descripcion'],
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () => onTap(index),
                        child: const Text('Añadir'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );



        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    ],
  );
}


  // Define una función que construye una columna de listas de elementos y devuelve un widget
  Widget _buildMenu() {

    // Devuelve una Columna que contiene tres listas de elementos: tapas, bebidas y postres
    return Column(
      children: [
        _buildList(
          tapas,
          (index) => sumar(index, 'tapas'),
          'No hay tapas disponibles en este establecimiento',
          'Tapas:',
        ),
        _buildList(
          bebidas,
          (index) => sumar(index, 'bebidas'),
          'No hay bebidas disponibles en este establecimiento',
          'Bebidas:',
        ),
        _buildList(
          postres,
          (index) => sumar(index, 'postres'),
          'No hay postres disponibles en este establecimiento',
          'Postres:',
        ),
      ],
    );
  }

  // Define una función que construye una columna con información sobre la cuenta y los pedidos y devuelve un widget
  Widget _buildCuenta() {

    // Devuelve una Columna que muestra la cuenta actual y un botón "Pagar" si hay pedidos pendientes
    return Column(
      children: [
        Text(
          'Cuenta: $cuenta€',
          style: const TextStyle(
            color: Colors.green,
            fontSize: 30,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 20),
        Visibility(
          visible: pedidos.isNotEmpty,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PaymentPage()),
              );
            },
            child: const Text('Pagar'),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Colors.green),
              foregroundColor:
                  MaterialStateProperty.all(Colors.white),
              padding: MaterialStateProperty.all(const EdgeInsets.symmetric(
                  vertical: 15, horizontal: 30)),
              textStyle: MaterialStateProperty.all(
                  const TextStyle(fontSize: 20)),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(10))),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Define una función que construye una columna con información sobre los pedidos y devuelve un widget
  Widget _buildPedidos() {

    // Devuelve una Columna que muestra la lista de pedidos actuales y permite eliminar elementos individuales
    return Column(
      children: [
        const Text(
          'Pedidos:',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
          ),
        ),
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  '${pedidos[index]['nombre']} x${pedidos[index]['cantidad']} (${pedidos[index]['cantidad'] * pedidos[index]['precio']}€)',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {

                      // Decrementa la cantidad del elemento seleccionado en 1
                      pedidos[index]['cantidad']--;

                      // Si la cantidad es 0, elimina el elemento de la lista y resta su precio a la cuenta total
                      if (pedidos[index]['cantidad'] == 0) {
                        cuenta -= pedidos[index]['precio'];
                        pedidos.removeAt(index);
                      } else { // Si la cantidad no es 0, actualiza el precio total restando el precio del elemento eliminado y sumando el precio actualizado según la nueva cantidad
                        cuenta -= pedidos[index]['precio'];
                        cuenta == pedidos[index]['cantidad'] * pedidos[index]['precio'];
                      }
                    });
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Bar Menu'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: bares.doc(widget.result).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No se han encontrado datos.'));
          }

          var dataBares = snapshot.data!.data() as Map<String, dynamic>;

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/menu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    dataBares['nombre'],
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                _buildMenu(),
                _buildPedidos(),
                _buildCuenta(),
              ],
            ),
          ),
          ],
        );
        },
      ),
      // Agregamos el botón debajo del cuerpo del scaffold.
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isCamareroEnCamino = true;
              });
              // Aquí podríamos agregar código para enviar una notificación al camarero.
            },
            child: Text(_isCamareroEnCamino
                ? 'Camarero en camino!'
                : 'Avisar a camarero'),
          ),
        ),
      ),
    );
  }
}