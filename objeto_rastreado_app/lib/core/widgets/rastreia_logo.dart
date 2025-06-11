import 'package:flutter/material.dart';

class RastreiaLogo extends StatelessWidget {
  final double size;
  final bool showIcon;

  const RastreiaLogo({
    Key? key,
    this.size = 40,
    this.showIcon = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon)
          Icon(
            Icons.location_on,
            size: size * 2,
            color: Theme.of(context).primaryColor,
          ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'RASTREIA',
              style: TextStyle(
                fontSize: size,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Theme.of(context).primaryColor,
                shadows: [
                  Shadow(
                    offset: const Offset(1, 1),
                    blurRadius: 2,
                    color: Theme.of(context).primaryColor.withOpacity(0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
