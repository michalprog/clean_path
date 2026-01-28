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

  InputDecoration _inputDecoration(String label, {required Color labelColor}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: labelColor),
      filled: true,
      fillColor: Colors.green.shade50,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.green.shade600, width: 2),
      ),
    );
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

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    final isLoading = context.select<AccountProvider, bool>((p) => p.isLoading);
    final user = _user;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(l10n.accountEditProfile),
        backgroundColor: Colors.green.shade50,
        foregroundColor: Colors.green.shade900,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  l10n.accountEditProfile,
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.green.shade900,
                  ),
                ),
              ),
              const SizedBox(height: 16),

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
                  // Domyślna klawiatura (zwykły tekst):
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: _inputDecoration(
                    l10n.accountUsernameLabel,
                    labelColor: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  maxLength: 80,
                  // Domyślna klawiatura (zwykły tekst):
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  autocorrect: false,
                  enableSuggestions: false,
                  textCapitalization: TextCapitalization.none,
                  decoration: _inputDecoration(
                    l10n.accountEmailLabel,
                    labelColor: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 20),
              ],

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed:
                      isLoading || user == null
                          ? null
                          : () => _saveChanges(context),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
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
                    foregroundColor: Colors.green.shade700,
                    side: BorderSide(color: Colors.green.shade300),
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
      ),
    );
  }
}
