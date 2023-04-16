import 'package:flutter/material.dart';

class Cuadrado extends StatelessWidget {
  final String rutaFoto;
  const Cuadrado({
    super.key,
    required this.rutaFoto,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[200],
      ),
      child: Image.asset(
        rutaFoto,
        height: 60,
      ),
    );
  }
}