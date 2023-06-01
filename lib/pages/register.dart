// Importar paquetes necesarios
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waiterbar/components/textfield.dart';

// Importar componentes y servicios personalizados
import '../components/boton.dart';
import '../components/cuadrado.dart';
import '../services/auth_service.dart';

// Crear página de registro
class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({Key? key, required this.onTap}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Crear controladores para los campos de texto
  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Función para crear un usuario nuevo
  void signUp() async {
    // Validar que se hayan llenado todos los campos
    if (nombreController.text.isEmpty ||
        apellidosController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showErrorDialog('Por favor, rellene todos los campos.');
      return;
    }
    // Validar que las contraseñas coincidan
    if (passwordController.text != confirmPasswordController.text) {
      _showErrorDialog('Las contraseñas no coinciden.');
      return;
    }

    // Mostrar indicador de carga
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      // Crear usuario nuevo en Firebase Auth
      final authResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Actualizar información del usuario en Firestore
      final user = authResult.user;
      await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'nombre': nombreController.text,
        'apellidos': apellidosController.text,
        'email': emailController.text,
      });

      // Ocultar indicador de carga y regresar a la página de inicio de sesión
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Manejar errores específicos de Firebase Auth
      Navigator.pop(context);
      if (e.code == 'invalid-email') {
        _showErrorDialog('El email introducido no es correcto.');
      } else if (e.code == 'user-disabled') {
        _showErrorDialog(
            'El usuario ha sido deshabilitado temporalmente. Por favor, inténtelo más tarde.');
      } else {
        _showErrorDialog('Ha ocurrido un error al crear el usuario.');
      }
    } catch (e) {
      // Manejar errores inesperados
      Navigator.pop(context);
      _showErrorDialog('Ha ocurrido un error inesperado. Por favor, inténtelo de nuevo.');
    }
  }

  // Función para mostrar un diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Aceptar'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/inicio_sesion.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo
                  const Icon(
                    Icons.restaurant_sharp,
                    size: 75,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '¡Vamos a registrarte!',
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Campos de texto para el registro
                  ModTextField(
                    controller: nombreController,
                    hintText: 'Nombre',
                    obscureText: false,
                    prefixIcon:
                        const Icon(Icons.drive_file_rename_outline_sharp),
                  ),
                  ModTextField(
                    controller: apellidosController,
                    hintText: 'Apellidos',
                    obscureText: false,
                    prefixIcon:
                        const Icon(Icons.drive_file_rename_outline_sharp),
                  ),
                  ModTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    prefixIcon: const Icon(Icons.mail),
                  ),
                  const SizedBox(height: 5),
                  ModTextField(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.password),
                  ),
                  const SizedBox(height: 5),
                  ModTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar contraseña',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.password),
                  ),
                  const SizedBox(height: 20),
                  // Botón para registrar usuario
                  Boton(
                    text: 'Registrarse',
                    onTap: signUp,
                  ),
                  const SizedBox(height: 20),
                  // Texto para iniciar sesión
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿Ya tienes una cuenta?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          ' Inicia sesión',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Botón para iniciar sesión con Google
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'O continua con',
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Botón para iniciar sesión con Google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Cuadrado(
                          onTap: () => AuthService().signInWithGoogle(),
                          rutaFoto: 'lib/images/google.png'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
