// Importamos las dependencias necesarias para el proyecto.
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:waiterbar/pages/auth_page.dart';
import 'firebase_options.dart';

void main() async {
  // Aseguramos la inicialización de los Widgets de Flutter.
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializamos Firebase con las opciones por defecto de la plataforma.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Ejecutamos la aplicación WaiterBar.
  runApp(WaiterBar());
}

class WaiterBar extends StatelessWidget {
  const WaiterBar({Key? key}) : super(key: key);

  // Este widget es la raíz de nuestra aplicación.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: AnimatedSplashScreen(
            duration: 1500,
            splash: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/images/logo.png",
                  height: 150,
                ),
                SizedBox(height: 40),
                Text(
                  "WaiterBar",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                ),
              ],
            ),
            nextScreen: AuthPage(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.bottomToTop,
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
