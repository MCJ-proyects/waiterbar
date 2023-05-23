import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:waiterbar/components/textfield.dart';

import '../components/boton.dart';
import '../components/cuadrado.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final nombreController = TextEditingController();
  final apellidosController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();


  //Crear usuario
  void signUp() async {

    //circulo de carga
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
            child: CircularProgressIndicator(),
        );
      },
    );

    try {

      if(passwordController.text == confirmPasswordController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        final user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .set({
            'nombre': nombreController.text,
            'apellidos': apellidosController.text,
            'email': emailController.text,
          });
      } else {
        Navigator.pop(context);
        passwordError();
      }
      //cerrar circulo de carga
      
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'invalid-email') {
        wrongEmail();
      } else {
        generalError();
      }
    }
    Navigator.pop(context);
    
  }

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
              child: const Text('Aceptar')
            )
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
              child: const Text('Aceptar')
            )
          ],
        );
      },
    );
  }

  void passwordError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Las contraseñas no coinciden'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text('Aceptar')
            )
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
          content: const Text('El usuario ha sido deshabilitado temporalmente. Por favor, inténtelo más tarde'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text('Aceptar')
            )
          ],
        );
      },
    );
  }

    void generalError() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text('Rellene los campos correctamente'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text('Aceptar')
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
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
          
                ModTextField(
                  controller: nombreController,
                  hintText: 'Nombre',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.drive_file_rename_outline_sharp),
                ),
                ModTextField(
                  controller: apellidosController,
                  hintText: 'Apellidos',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.drive_file_rename_outline_sharp),
                ),
                //email
                ModTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  prefixIcon: const Icon(Icons.mail),
                ),
          
                const SizedBox(height: 5),
          
                //password
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
          
                //sign in button
                Boton(
                  text: 'Registrarse',
                  onTap: signUp,
                ),
          
                const SizedBox(height: 20),
          
                              //register text
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
                        )
                      ),
                    ),
                  ],
                ),
          
                const SizedBox(height: 20),
          
                //continue with google sign in button
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
                    ],),
                ),
          
                const SizedBox(height: 25),
          
                //google sign in button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Cuadrado(
                      onTap:() => AuthService().signInWithGoogle(),
                      rutaFoto: 'lib/images/google.png'
                    ),
                  ],
                ),
          
              ],
            ),
          ),
        ),
      ),
    );
  }
}