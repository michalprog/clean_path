import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'account_edit_view.dart';
import '/l10n/app_localizations.dart';
import '/providers/account_provider.dart';
import 'account_info_tile.dart';
import 'account_row.dart';

class AccountBottomSheet extends StatelessWidget {
  const AccountBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final l10n = AppLocalizations.of(context)!;

    final user = context.select<AccountProvider, dynamic>((p) => p.user);
    final isLoading = context.select<AccountProvider, bool>((p) => p.isLoading);

    final username = user?.username ?? l10n.accountDefaultUsername;
    final email = user?.email ?? l10n.accountNoEmail;
    final level = user?.level ?? 0;
    final xp = user?.xp ?? 0;
    final status = user?.status ?? 0;
    final streak = user?.streak ?? 0;

    final joinDate = _formatJoinDate(context, l10n, user?.joinDate);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        decoration: BoxDecoration(
          color: cs.surface,
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
                color: cs.outlineVariant.withOpacity(0.7),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 16),
            CircleAvatar(
              radius: 36,
              backgroundColor: cs.primaryContainer,
              foregroundColor: cs.onPrimaryContainer,
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

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    cs.primary.withOpacity(0.14),
                    cs.secondary.withOpacity(0.14),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.outlineVariant.withOpacity(0.6)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AccountInfoTile(
                    icon: Icons.emoji_events,
                    label: l10n.accountLevelLabel,
                    value: level.toString(),
                    color: cs.primary,
                  ),
                  AccountInfoTile(
                    icon: Icons.auto_graph,
                    label: l10n.accountXpLabel,
                    value: xp.toString(),
                    color: cs.secondary,
                  ),
                  AccountInfoTile(
                    icon: Icons.local_fire_department,
                    label: l10n.accountStreakLabel,
                    value: l10n.accountStreakValue(streak),
                    color: cs.tertiary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            Divider(color: cs.outlineVariant.withOpacity(0.7), height: 1),
            const SizedBox(height: 16),

            AccountRow(
              icon: status == 1 ? Icons.check_circle : Icons.cancel,
              title: l10n.accountStatusTitle,
              value: _statusLabel(l10n, status),
              color: status == 1 ? Colors.green : cs.outline,
            ),
            const SizedBox(height: 8),
            AccountRow(
              icon: Icons.calendar_today,
              title: l10n.accountJoinedTitle,
              value: joinDate,
              color: cs.secondary,
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    isLoading
                        ? null
                        : () {
                          showModalBottomSheet<void>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder:
                                (context) => Padding(
                                  padding: EdgeInsets.only(
                                    bottom:
                                        MediaQuery.of(
                                          context,
                                        ).viewInsets.bottom,
                                  ),
                                  child: const AccountEditView(),
                                ),
                          );
                        },
                icon: const Icon(Icons.edit),
                label: Text(l10n.accountEditProfile),
                style: OutlinedButton.styleFrom(
                  foregroundColor: cs.primary,
                  side: BorderSide(color: cs.outline),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
                label: Text(l10n.accountClose),
                style: FilledButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

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
    AppLocalizations l10n,
    DateTime? date,
  ) {
    if (date == null) return l10n.accountNoData;
    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMM(locale.toString()).format(date);
  }

  String _statusLabel(AppLocalizations l10n, int status) {
    return status == 1 ? l10n.accountStatusActive : l10n.accountStatusInactive;
  }
}
