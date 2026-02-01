import 'package:clean_path/widgets/user_widgets/account_info_tile.dart';
import 'package:clean_path/widgets/user_widgets/account_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '/l10n/app_localizations.dart';
import '/providers/account_provider.dart';
import 'account_edit_view.dart';


class AccountSummaryView extends StatelessWidget {
  const AccountSummaryView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final accountProvider = context.watch<AccountProvider>();
    final user = accountProvider.user;
    final username = user?.username ?? l10n.accountDefaultUsername;
    final email = user?.email ?? l10n.accountNoEmail;
    final level = user?.level ?? 0;
    final xp = user?.xp ?? 0;
    final streak = user?.streak ?? 0;
    final status = user?.status ?? 0;
    final joinDate = _formatJoinDate(context, user?.joinDate, l10n);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade50,
                Colors.green.shade100,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              CircleAvatar(
                radius: 38,
                backgroundColor: Colors.green.shade200,
                child: Icon(
                  Icons.person,
                  size: 42,
                  color: Colors.green.shade900,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                username,
                style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                email,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _openEditProfile(context),
                  icon: const Icon(Icons.edit),
                  label: Text(l10n.accountEditProfile),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.green.shade100,
                Colors.green.shade200,
                Colors.green.shade300,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
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
        AccountRow(
          icon: Icons.check_circle,
          title: l10n.accountStatusTitle,
          value: status == 1
              ? l10n.accountStatusActive
              : l10n.accountStatusInactive,
          color: status == 1 ? Colors.green.shade700 : Colors.grey,
        ),
        const SizedBox(height: 12),
        AccountRow(
          icon: Icons.calendar_today,
          title: l10n.accountJoinedTitle,
          value: joinDate,
          color: Colors.green.shade400,
        ),
        if (accountProvider.isLoading) ...[
          const SizedBox(height: 16),
          Center(
            child: Text(
              l10n.accountLoading,
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ],
    );
  }

  void _openEditProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AccountEditView()),
    );
  }

  String _formatJoinDate(
      BuildContext context,
      DateTime? date,
      AppLocalizations l10n,
      ) {
    if (date == null) {
      return l10n.accountNoData;
    }

    final locale = Localizations.localeOf(context);
    return DateFormat.yMMMM(locale.toString()).format(date);
  }
}