import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '/providers/account_provider.dart';
import '/user_views/account_edit_view.dart';
import '/user_views/account_info_tile.dart';
import '/user_views/account_row.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    // Mniej rebuildów: pobieramy tylko potrzebne pola.
    final user = context.select<AccountProvider, dynamic>((p) => p.user);
    final isLoading = context.select<AccountProvider, bool>((p) => p.isLoading);

    final username = user?.username ?? l10n.accountDefaultUsername;
    final email = user?.email ?? l10n.accountNoEmail;
    final level = user?.level ?? 0;
    final xp = user?.xp ?? 0;
    final streak = user?.streak ?? 0;
    final status = user?.status ?? 0;
    final joinDate = _formatJoinDate(context, user?.joinDate, l10n);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade50,
              Colors.green.shade100,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
                color: cs.outlineVariant.withOpacity(0.8),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16),

            // Avatar + podstawowe dane
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.green.shade200,
              foregroundColor: Colors.green.shade900,
              child: const Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 12),

            Text(
              username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),

            Text(
              email,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // Kafelki ze statystykami konta.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountInfoTile(
                    icon: Icons.emoji_events,
                    label: l10n.accountLevelLabel,
                    value: level.toString(),
                    color: Colors.green.shade700,
                  ),
                  AccountInfoTile(
                    icon: Icons.auto_graph,
                    label: l10n.accountXpLabel,
                    value: xp.toString(),
                    color: Colors.green.shade600,
                  ),
                  AccountInfoTile(
                    icon: Icons.local_fire_department,
                    label: l10n.accountStreakLabel,
                    value: l10n.accountStreakValue(streak),
                    color: Colors.green.shade800,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(height: 1, color: Colors.green.shade200),
            const SizedBox(height: 16),

            // Wiersz ze statusem konta.
            AccountRow(
              icon: status == 1 ? Icons.check_circle : Icons.cancel,
              title: l10n.accountStatusTitle,
              value: _statusLabel(status, l10n),
              color: status == 1 ? Colors.green.shade700 : Colors.green.shade300,
            ),
            const SizedBox(height: 8),

            // Wiersz z datą dołączenia.
            AccountRow(
              icon: Icons.calendar_today,
              title: l10n.accountJoinedTitle,
              value: joinDate,
              color: Colors.green.shade500,
            ),

            const SizedBox(height: 16),

            // Przycisk do edycji profilu.
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isLoading ? null : () => _openEditProfile(context),
                icon: const Icon(Icons.edit),
                label: Text(l10n.accountEditProfile),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green.shade700,
                  side: BorderSide(color: Colors.green.shade300),
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
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: Text(l10n.accountClose),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            // Informacja o ładowaniu danych konta.
            if (isLoading) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    l10n.accountLoading,
                    style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatJoinDate(
      BuildContext context,
      DateTime? date,
      AppLocalizations l10n,
      ) {
    if (date == null) return l10n.accountNoData;
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMM(locale.toString()).format(date);
  }

  String _statusLabel(int status, AppLocalizations l10n) {
    return status == 1 ? l10n.accountStatusActive : l10n.accountStatusInactive;
  }

  void _openEditProfile(BuildContext context) {
    final navigator = Navigator.of(context, rootNavigator: true);
    Navigator.of(context).pop(); // zamykamy bottom sheet
    navigator.push(
      MaterialPageRoute(builder: (_) => const AccountEditView()),
    );
  }
}
