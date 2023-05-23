import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String text;
  final String subtitle;
  const Header({required this.text,this.subtitle="", Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          Text(
            subtitle,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.normal, color: Colors.grey),
          ),
        ],
    );
  }
}