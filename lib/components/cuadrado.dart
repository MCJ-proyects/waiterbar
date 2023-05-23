import 'package:flutter/material.dart';

class Cuadrado extends StatelessWidget {
  final String rutaFoto;
  final Function()? onTap;
  const Cuadrado({
    super.key,
    required this.rutaFoto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}