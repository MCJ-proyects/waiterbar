// Importación de paquetes y componentes necesarios
import 'package:firebase_auth/firebase_auth.dart'; // Importa el paquete Firebase Auth para la autenticación de usuarios
import 'package:flutter/material.dart'; // Importa el paquete Flutter Material Design
import 'package:connectivity/connectivity.dart'; // Importa el paquete Connectivity para comprobar la conexión a internet del usuario
import 'package:animated_text_kit/animated_text_kit.dart'; // Importa el paquete Animated Text Kit para animaciones de texto

import '../components/boton.dart'; // Importa el componente Boton personalizado
import '../components/cuadrado.dart'; // Importa el componente Cuadrado personalizado
import '../components/textfield.dart'; // Importa el componente TextField personalizado
import '../services/auth_service.dart'; // Importa el servicio AuthService para la autenticación de usuarios

// Clase LoginPage que define la página de inicio de sesión
class LoginPage extends StatefulWidget {
  
  final Function()? onTap; // Define una función que se ejecutará cuando se toque en la pantalla

  const LoginPage({Key? key, required this.onTap}) : super(key: key); // Constructor de la clase LoginPage

  @override
  State<LoginPage> createState() => _LoginPageState(); // Crea un estado mutable para la clase LoginPage

}


// Clase de estado correspondiente a la clase LoginPage
class _LoginPageState extends State<LoginPage> {
  // Controladores de los campos de texto para email y contraseña
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Función para iniciar sesión con Firebase authentication
  Future<void> signIn() async {
    // Comprobar si los campos de email y contraseña están vacíos
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      generalError('Rellene los campos correctamente');
      return;
    }

    // Comprobar la conectividad a internet
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      generalError('No hay conexión a internet');
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
      // Intentar iniciar sesión con Firebase authentication
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      // Cerrar el indicador de carga
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Cerrar el indicador de carga
      Navigator.pop(context);
      // Mostrar mensaje de error específico según el tipo de error que ocurrió
      switch (e.code) {
        case 'user-not-found':
        case 'invalid-email':
          wrongEmail();
          break;
        case 'wrong-password':
          wrongPassword();
          break;
        case 'too-many-requests':
          disabledUserError();
          break;
        default:
          generalError('Ha ocurrido un error. Por favor, inténtelo de nuevo');
          break;
      }
    } catch (e) {
      // Cerrar el indicador de carga
      Navigator.pop(context);
      generalError('Ha ocurrido un error. Por favor, inténtelo de nuevo');
    }
  }

  // Funciones para mostrar mensajes de error en cuadros de diálogo
  void wrongEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('El email introducido no es correcto'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'))
          ],
        );
      },
    );
  }

  void wrongPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('La contraseña introducida no es correcta'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'))
          ],
        );
      },
    );
  }

  void disabledUserError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'El usuario ha sido deshabilitado temporalmente. Por favor, inténtelo más tarde'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Aceptar'))
          ],
        );
      },
    );
  }

  void generalError(String message) {
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
                child: const Text('Aceptar'))
          ],
        );
      },
    );
  }

  // Función para construir la página de inicio de sesión
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
                  // Logo de la aplicación
                  const Icon(
                    Icons.restaurant_sharp,
                    size: 75,
                  ),

                  const SizedBox(height: 15),

                  // Título de bienvenida
                  Text(
                    '¡Bienvenido a WaiterBar!',
                    style: TextStyle(
                      color: Colors.grey[850],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Migontama',
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Texto que aparecerá una palabra a la vez
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText('Tu servicio de pedidos personal, portatil y sencillo', textStyle:  TextStyle(fontSize: 15, fontFamily: 'Bobbers'))
                    ],
                    isRepeatingAnimation: false,
                    onTap: () {},
                  ),

                  const SizedBox(height: 25),

                  // Campo de texto para email
                  ModTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    prefixIcon: const Icon(Icons.mail),
                  ),

                  const SizedBox(height: 10),

                  // Campo de texto para contraseña
                  ModTextField(
                    controller: passwordController,
                    hintText: 'Contraseña',
                    obscureText: true,
                    prefixIcon: const Icon(Icons.password),
                  ),

                  const SizedBox(height: 15),

                  // Botón para iniciar sesión
                  Boton(
                    text: 'Iniciar sesión',
                    onTap: signIn,
                  ),

                  const SizedBox(height: 20),

                  // Texto para registrar una cuenta nueva
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 13,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                            ' Regístrate',
                            style: TextStyle(
                              color: Color.fromARGB(255, 33, 243, 47),
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            )
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // Botón de inicio de sesión con Google
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: Colors.grey[600],
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
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botón de inicio de sesión con Google
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Cuadrado(
                          onTap: () => AuthService().signInWithGoogle(),
                          rutaFoto: 'lib/images/google.png')
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
