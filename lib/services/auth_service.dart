// Importar las dependencias necesarias
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Definir la clase AuthService
class AuthService {
  // Método para iniciar sesión con Google
  Future<User?> signInWithGoogle() async {
    try {
      // Iniciar sesión con Google
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // Si el usuario cancela el inicio de sesión, lanzar una excepción
        throw FirebaseAuthException(
          code: "ERROR_ABORTED_BY_USER",
          message: "Inicio de sesión cancelado por el usuario",
        );
      }
      // Obtener las credenciales de autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Iniciar sesión en Firebase con las credenciales obtenidas
      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      // Guardar el nombre del usuario para uso futuro
      final List<String> displayNameParts =
          user?.displayName?.split(' ') ?? <String>[];
      final String nombre =
          displayNameParts.isNotEmpty ? displayNameParts.first : '';
      final String apellidos =
          displayNameParts.length > 1 ? displayNameParts.sublist(1).join(' ') : '';

      // Guardar la información del usuario en Firestore
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'nombre': nombre,
        'apellidos': apellidos,
        'email': user.email,
      });

      // Devolver el objeto de usuario
      return user;
    } catch (e) {
      // Si ocurre un error, imprimirlo y lanzar la excepción nuevamente
      print(e.toString());
      rethrow;
    }
  }
}
