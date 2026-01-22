import 'package:flutter/material.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 36,
              backgroundColor: colorScheme.primary.withOpacity(0.15),
              child: Icon(
                Icons.person,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Użytkownik Clean Path",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "user@cleanpath.app",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.primary.withOpacity(0.15),
                    colorScheme.secondary.withOpacity(0.15),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoTile(
                    context,
                    icon: Icons.emoji_events,
                    label: "Poziom",
                    value: "5",
                    color: Colors.deepPurple,
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.auto_graph,
                    label: "XP",
                    value: "1 200",
                    color: Colors.teal,
                  ),
                  _buildInfoTile(
                    context,
                    icon: Icons.local_fire_department,
                    label: "Seria",
                    value: "7 dni",
                    color: Colors.deepOrange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildAccountRow(
              context,
              icon: Icons.check_circle,
              title: "Status konta",
              value: "Aktywne",
              color: Colors.green,
            ),
            const SizedBox(height: 8),
            _buildAccountRow(
              context,
              icon: Icons.calendar_today,
              title: "Dołączyłeś",
              value: "Styczeń 2024",
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: const Text("Zamknij"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildInfoTile(
    BuildContext context, {
      required IconData icon,
      required String label,
      required String value,
      required Color color,
    }) {
  return Column(
    children: [
      CircleAvatar(
        radius: 18,
        backgroundColor: color.withOpacity(0.15),
        child: Icon(icon, size: 18, color: color),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.grey.shade700,
        ),
      ),
    ],
  );
}

Widget _buildAccountRow(
    BuildContext context, {
      required IconData icon,
      required String title,
      required String value,
      required Color color,
    }) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
      ],
    ),
  );
}