// Importamos las librerías necesarias para trabajar con Firebase y Flutter
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

// Importamos los componentes que vamos a utilizar en la página
import '../scanner.dart';
import '../pages/user_profile.dart';

// Creamos una clase StatefulWidget llamada HomePage
class HomePage extends StatefulWidget {
  // Definimos el constructor de la clase, que recibe un key
  HomePage({required this.key});

  // Declaramos una variable final que va a ser una instancia de GlobalKey<ScaffoldState>
  final GlobalKey<ScaffoldState> key;

  // Sobrescribimos el método createState() para crear una nueva instancia de _HomePageState
  @override
  _HomePageState createState() => _HomePageState();
}

// Creamos una clase State<_HomePageState> llamada _HomePageState
class _HomePageState extends State<HomePage> {
  // Definimos una variable entera llamada _selectedIndex y le asignamos el valor 0
  int _selectedIndex = 0;

  // Creamos una instancia de FirebaseFirestore y declaramos una CollectionReference llamada users
  final db = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Creamos una función llamada signUserOut que se encarga de cerrar sesión del usuario actual
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  // Creamos una función llamada _onItemTapped que se encarga de cambiar el índice seleccionado en la barra de navegación inferior
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Sobrescribimos el método build() para construir la página
  @override
  Widget build(BuildContext context) {
    // Obtenemos el ID del usuario actualmente logueado en Firebase Auth
    var idUser = FirebaseAuth.instance.currentUser!.uid;

    // Construimos la página usando Scaffold
    return Scaffold(
      extendBody: true,
      key: widget.key,
      appBar: AppBar(
        // Mostramos un título diferente dependiendo del índice seleccionado
        title: _selectedIndex == 0
            ? const Text('Inicio')
            : const Text('Datos del usuario'),

        // Mostramos un icono de logout en la barra de navegación superior si estamos en la página de inicio
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  onPressed: signUserOut,
                  icon: const Icon(Icons.logout),
                )
              ]
            : null,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/perfil_inicio.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: _selectedIndex == 0
            ? FutureBuilder<DocumentSnapshot>(
                // Si estamos en la página de inicio, construimos un FutureBuilder que se encarga de obtener los datos del usuario actual desde Firestore
                future: users.doc(idUser).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Si tenemos los datos del usuario, los mostramos en pantalla
                    var usuario = snapshot.data!.data() as Map<String, dynamic>;
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(height: 75.0),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Center(
                              child: ProfilePicture(
                                name:
                                    '${usuario['nombre']} ${usuario['apellidos']}',
                                radius: 70,
                                fontsize: 40,
                                count: 1,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 20),
                            child:                   // Texto que aparecerá una palabra a la vez
                              Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text(
                                      '¿Que te apetece hoy? ',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    AnimatedTextKit(
                                      animatedTexts: [
                                        TypewriterAnimatedText('Hamburguesería', textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.red)),
                                        TypewriterAnimatedText('Pizzería', textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.orange)),
                                        TypewriterAnimatedText('Restaurante 5 estrellas', textStyle: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.pink)),
                                      ],
                                      repeatForever: true,
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 35),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) => Scanner(),
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(9.0),
                                child: Column(
                                  children: [
                                    GestureDetector(
                                        child: const Icon(
                                          Icons.qr_code_scanner_rounded,
                                          color: Colors.white,
                                          size: 100,
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Scanner()),
                                          );
                                        }),
                                    Text(
                                      "Escanear codigo QR",
                                      style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Si aún no tenemos los datos del usuario, mostramos un CircularProgressIndicator
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              )
            : UserDetailsPage(), // Si estamos en la página de perfil, mostramos UserDetailsPage()
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(148, 255, 255, 255),
        // Creamos una barra de navegación inferior con dos elementos
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],

        // Seleccionamos el índice actual según el valor de _selectedIndex
        currentIndex: _selectedIndex,

        // Definimos el color del elemento seleccionado
        selectedItemColor: Colors.blueAccent,

        // Cuando se toca un elemento de la barra de navegación inferior, llamamos a la función _onItemTapped para cambiar el índice seleccionado
        onTap: _onItemTapped,
      ),
    );
  }
}
