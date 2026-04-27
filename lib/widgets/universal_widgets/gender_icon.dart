import 'package:flutter/material.dart';

class GenderIcon extends StatelessWidget {
  const GenderIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 42,
      height: 36,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(Icons.female, size: 28),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Icon(Icons.male, size: 28),
          ),
        ],
      ),
    );
  }
}