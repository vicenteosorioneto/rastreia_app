import 'package:flutter/material.dart';

class RastreiaLogo extends StatelessWidget {
  final double size;
  final Color color;

  const RastreiaLogo({
    Key? key,
    this.size = 40,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'RASTREIA',
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
        letterSpacing: 2,
      ),
    );
  }
}
