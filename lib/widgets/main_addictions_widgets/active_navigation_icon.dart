import 'package:flutter/material.dart';

class ActiveNavigationIcon extends StatelessWidget {
  const ActiveNavigationIcon({
    required this.onPressed,
    required this.icon,
    required this.isActive,
  });

  final VoidCallback onPressed;
  final Widget icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final activeColor = Colors.green.shade900;
    return IconButton(
      onPressed: onPressed,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          IconTheme(
            data: IconThemeData(
              color: isActive ? activeColor : null,
            ),
            child: icon,
          ),
          if (isActive)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withOpacity(0.6),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}