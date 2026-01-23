import 'package:flutter/material.dart';

class AccountInfoTile extends StatelessWidget {
  const AccountInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withOpacity(0.16),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: tt.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }
}