import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/data_types/user.dart';
import '/l10n/app_localizations.dart';
import '/providers/account_provider.dart';

class AccountEditView extends StatefulWidget {
  const AccountEditView({super.key});

  @override
  State<AccountEditView> createState() => _AccountEditViewState();
}

class _AccountEditViewState extends State<AccountEditView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  User? _user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = context.read<AccountProvider>().user;
    if (_user != user) {
      _user = user;
      _usernameController.text = user?.username ?? '';
      _emailController.text = user?.email ?? '';
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(BuildContext context) async {
    final user = _user;
    if (user == null) return;
    final provider = context.read<AccountProvider>();
    final trimmedUsername = _usernameController.text.trim();
    final trimmedEmail = _emailController.text.trim();
    final updatedUser = user.copyWith(
      username: trimmedUsername.isEmpty ? user.username : trimmedUsername,
      email: trimmedEmail.isEmpty ? null : trimmedEmail,
    );
    await provider.updateUser(updatedUser, previousUsername: user.username);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;
    final isLoading = context.select<AccountProvider, bool>((p) => p.isLoading);
    final user = _user;

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
            Text(
              l10n.accountEditProfile,
              style: tt.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            if (user == null) ...[
              Text(
                l10n.accountNoData,
                style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
              ),
              const SizedBox(height: 20),
            ] else ...[
              TextFormField(
                controller: _usernameController,
                maxLength: 40,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: l10n.accountUsernameLabel,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                maxLength: 80,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.accountEmailLabel,
                ),
              ),
              const SizedBox(height: 20),
            ],
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                isLoading || user == null ? null : () => _saveChanges(context),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.accountSaveChanges),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(l10n.accountClose),
              ),
            ),
          ],
        ),
      ),
    );
  }
}