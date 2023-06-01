// Importamos las librerías necesarias
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waiterbar/pages/home_page.dart';
import 'login_or_register_page.dart';

// Creamos una clave global para el Scaffold
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

// Definimos un widget de página de autenticación
class AuthPage extends StatelessWidget {

  // Constructor constante con super.key
  const AuthPage({super.key});

  // Método que construye la página de autenticación
  @override
  Widget build(BuildContext context) {

    // Retornamos un Scaffold con un StreamBuilder que escucha los cambios de autenticación
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Si hay datos de usuario autenticado, retornamos la HomePage
            return HomePage(key: _scaffoldKey);
          } else {
            // Si no hay datos de usuario autenticado, retornamos la página de Login o Registro
            return const LoginOrRegisterPage(key: ValueKey('login_or_register_page'));
          }
        },
      ),
    );

  }

}
