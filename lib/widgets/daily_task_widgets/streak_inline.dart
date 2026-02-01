import 'package:flutter/material.dart';

class StreakInline extends StatelessWidget {
  const StreakInline({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '+$value',
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w900,
            color: cs.primary,
          ),
        ),
        const SizedBox(width: 4),
        Icon(Icons.local_fire_department_rounded, size: 16, color: cs.primary),
      ],
    );
  }
}