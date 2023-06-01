// Importamos las librerías necesarias
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';

// Creamos una nueva clase StatefulWidget para nuestra página de detalles del usuario
class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({Key? key}) : super(key: key);

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

// Creamos la clase State correspondiente a nuestro StatefulWidget
class _UserDetailsPageState extends State<UserDetailsPage> {
  // Creamos instancias de Firebase y Firestore
  final db = FirebaseFirestore.instance;
  final currentUser = FirebaseAuth.instance.currentUser;

  // Creamos controladores de texto para los campos de nombre, apellidos, email y nueva contraseña
  late TextEditingController _nombreController;
  late TextEditingController _apellidosController;
  late TextEditingController _emailController;
  late TextEditingController _newPasswordController;

  // Creamos variables booleanas para indicar si estamos editando o cargando datos y una variable para mostrar errores
  bool _isEditing = false;
  bool _isLoading = true;
  String? _errorMessage;

  // Sobreescribimos el método initState para inicializar nuestros controladores de texto y cargar los datos del usuario
  @override
  void initState() {
    super.initState();
    _nombreController = TextEditingController();
    _apellidosController = TextEditingController();
    _emailController = TextEditingController();
    _newPasswordController = TextEditingController();
    loadUserData();
  }

  // Creamos un método asíncrono para cargar los datos del usuario desde Firestore
  Future<void> loadUserData() async {
    try {
      final snapshot =
          await db.collection('users').doc(currentUser?.uid).get();
      if (snapshot.exists) {
        final userData = snapshot.data();
        setState(() {
          _nombreController.text = userData?['nombre'] ?? '';
          _apellidosController.text = userData?['apellidos'] ?? '';
          _emailController.text = userData?['email'] ?? '';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Error: User data not found.';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error: ${error.toString()}';
        _isLoading = false;
      });
    }
  }

  // Sobreescribimos el método build para construir nuestra página
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Fondo de pantalla
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/images/perfil_inicio.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido principal
          Visibility(
            visible: !_isLoading,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Imagen de perfil
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ProfilePicture(
                        name: '${_nombreController.text} ${_apellidosController.text}',
                        radius: 60,
                        fontsize: 35,
                        count: 1,
                      ),
                    ),
                  ),
                  // Campo de nombre
                  Text('Nombre', style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _nombreController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Introduzca su nombre',
                    ),
                  ),
                  // Mostramos un mensaje de error si el campo está vacío y hay un error
                  if (_errorMessage != null && _nombreController.text.isEmpty)
                    Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  SizedBox(height: 16.0),
                  // Campo de apellidos
                  Text('Apellidos', style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _apellidosController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Introduzca sus apellidos',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Campo de email
                  Text('Email', style: TextStyle(fontSize: 18.0)),
                  SizedBox(height: 8.0),
                  TextFormField(
                    controller: _emailController,
                    enabled: _isEditing,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Introduzca su email',
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Botón para editar o guardar los cambios
                  Center(
                    child: TextButton(
                      onPressed: () async {
                        setState(() {
                          _isEditing = !_isEditing;
                          _errorMessage = null;
                        });

                        if (!_isEditing) {
                          if (_nombreController.text.isEmpty) {
                            setState(() {
                              _errorMessage = 'Por favor, introduzca su nombre.';
                            });
                          } else {
                            try {
                              // Guardamos los cambios en Firestore
                              await db.collection('users').doc(currentUser?.uid).update({
                                'nombre': _nombreController.text,
                                'apellidos': _apellidosController.text,
                                'email': _emailController.text,
                              });
                              setState(() {
                                _errorMessage = null;
                              });
                            } catch (error) {
                              setState(() {
                                _errorMessage = 'Error: ${error.toString()}';
                              });
                            }
                          }
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(_isEditing ? Icons.save : Icons.edit),
                          SizedBox(width: 8.0),
                          Text(_isEditing ? 'Guardar' : 'Editar'),
                        ],
                      ),
                    ),
                  ),
                  // Mostramos un mensaje de error si el campo está vacío y hay un error
                  if (_errorMessage != null && _nombreController.text.isEmpty)
                  Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red))),
                  SizedBox(height: 16.0),
                  // Botón para cambiar la contraseña
                  Center(
                    child: ElevatedButton(
                      onPressed: _isEditing ? null : () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Cambiar contraseña'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextFormField(
                                    controller: _newPasswordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Introduzca su nueva contraseña',
                                    ),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: Text('Cambiar'),
                                  onPressed: () async {
                                    if (_newPasswordController.text.isEmpty) {
                                      setState(() {
                                        _errorMessage = 'Por favor, introduzca su nueva contraseña.';
                                      });
                                    } else {
                                      try {
                                        // Cambiamos la contraseña del usuario
                                        await currentUser?.updatePassword(_newPasswordController.text);
                                        Navigator.of(context).pop();
                                      } catch (error) {
                                        setState(() {
                                          _errorMessage = 'Error: ${error.toString()}';
                                        });
                                      }
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Text('Cambiar contraseña'),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  // Mostramos un mensaje de error general si lo hay
                  if (_errorMessage != null)
                    Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                ],
              ),
            ),
          ),
          // Mostramos un indicador de carga mientras se cargan los datos
          Visibility(
            visible: _isLoading,
            child: Container(
              color: Colors.white.withOpacity(0.8),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
