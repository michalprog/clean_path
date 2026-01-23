import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '/providers/account_provider.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accountProvider = context.watch<AccountProvider>();
    final l10n = AppLocalizations.of(context)!;
    final user = accountProvider.user;
    final username = user?.username ?? l10n.accountDefaultUsername;
    final email = user?.email ?? l10n.accountNoEmail;
    final level = user?.level ?? 0;
    final xp = user?.xp ?? 0;
    final status = user?.status ?? 0;
    final joinDate = _formatJoinDate(context, l10n, user?.joinDate);

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
            // Uchwyt do przeciągania dolnego arkusza.
            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16),
            // Avatar użytkownika.
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
            // Nazwa użytkownika.
            Text(
              username,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // Adres e-mail.
            Text(
              email,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            // Kafelki ze statystykami konta.
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
                  AccountBottomSheet._buildInfoTile(
                    context,
                    icon: Icons.emoji_events,
                    label: l10n.accountLevelLabel,
                    value: level.toString(),
                    color: Colors.deepPurple,
                  ),
                  AccountBottomSheet._buildInfoTile(
                    context,
                    icon: Icons.auto_graph,
                    label: l10n.accountXpLabel,
                    value: xp.toString(),
                    color: Colors.teal,
                  ),
                  AccountBottomSheet._buildInfoTile(
                    context,
                    icon: Icons.local_fire_department,
                    label: l10n.accountStreakLabel,
                    value: l10n.accountStreakValue(7),
                    color: Colors.deepOrange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Wiersz ze statusem konta.
            AccountBottomSheet._buildAccountRow(
              context,
              icon: Icons.check_circle,
              title: l10n.accountStatusTitle,
              value: _statusLabel(l10n, status),
              color: status == 1 ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 8),
            // Wiersz z datą dołączenia.
            AccountBottomSheet._buildAccountRow(
              context,
              icon: Icons.calendar_today,
              title: l10n.accountJoinedTitle,
              value: joinDate,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 12),
            // Przycisk do edycji profilu (na razie bez akcji).
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit),
                label: Text(l10n.accountEditProfile),
                style: OutlinedButton.styleFrom(
                  foregroundColor: colorScheme.primary,
                  side: BorderSide(color: colorScheme.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Przycisk zamknięcia arkusza.
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: Text(l10n.accountClose),
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
            // Informacja o ładowaniu danych konta.
            if (accountProvider.isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  l10n.accountLoading,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _formatJoinDate(
      BuildContext context,
      AppLocalizations l10n,
      DateTime? date,
      ) {
    if (date == null) {
      return l10n.accountNoData;
    }

    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMM(locale.toString()).format(date);
  }

  String _statusLabel(AppLocalizations l10n, int status) {
    return status == 1
        ? l10n.accountStatusActive
        : l10n.accountStatusInactive;
  }

  static Widget _buildInfoTile(
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

  static Widget _buildAccountRow(
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
}
