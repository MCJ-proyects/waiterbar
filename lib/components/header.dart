// Importa el paquete de material design de flutter
import 'package:flutter/material.dart';

// Define la clase Header que extiende de StatelessWidget
class Header extends StatelessWidget {
  // Declara dos variables finales que serán requeridas en el constructor
  final String text;
  final String subtitle;

  // Crea el constructor de la clase Header
  const Header({
    required this.text,
    this.subtitle = "",
    Key? key,
  }) : super(key: key);

  // Sobrescribe el método build para construir el widget
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Centra el texto del título y lo estiliza con negrita y tamaño de fuente grande
        Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        // Centra el texto del subtítulo y lo estiliza con cursiva, tamaño de fuente mediano y color gris oscuro
        Center(
          child: Text(
            subtitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
              color: const Color.fromARGB(255, 121, 117, 117),
            ),
          ),
        ),
      ],
    );
  }
}
