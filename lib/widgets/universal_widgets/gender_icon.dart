import 'package:flutter/material.dart';

class GenderIcon extends StatelessWidget {
  const GenderIcon({super.key, this.size = 42, this.color = Colors.black});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final femaleSize = size * 0.78;
    final maleSize = size * 0.78;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(Icons.female, size: femaleSize, color: color),
          ),
          Positioned(
            right: -size * 0.01,
            top: -size * 0.12,
            child: Icon(Icons.male, size: maleSize, color: color),
          ),
        ],
      ),
    );
  }
}