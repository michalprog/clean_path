import 'package:flutter/material.dart';

class LanguageTile extends StatelessWidget {
  const LanguageTile({
    required this.locale,
    required this.name,
    required this.flag,
    required this.isSelected,
    required this.selectedLabel,
    required this.onTap,
    super.key,
  });

  final Locale locale;
  final String name;
  final String flag;
  final bool isSelected;
  final String selectedLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected ? Colors.greenAccent.withOpacity(0.2) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      elevation: isSelected ? 3 : 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: 400,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                flag,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                locale.languageCode.toUpperCase(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[700],
                  letterSpacing: 0.5,
                ),
              ),
              if (isSelected) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green[600],
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      selectedLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.green[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
