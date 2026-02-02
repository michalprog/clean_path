import 'package:flutter/material.dart';

class RankIndicator extends StatelessWidget {
  const RankIndicator({required this.rank});

  final int rank;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final accentColor = Colors.green.shade800;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.emoji_events_rounded, size: 16, color: accentColor),
        const SizedBox(height: 2),
        Text(
          '$rank',
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: cs.onSurface,
          ),
        ),
      ],
    );
  }
}