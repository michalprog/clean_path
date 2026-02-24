import 'package:flutter/material.dart';

import '/l10n/app_localizations.dart';

class DailyWelcomeDialog extends StatelessWidget {
  const DailyWelcomeDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      alignment: Alignment.center,
      backgroundColor: const Color(0xFFF3F7F4),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFFDCEBDD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.waving_hand_rounded, color: Color(0xFF507A57), size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.dailyWelcomeTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF2F4A33),
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
        ],
      ),
      content: Text(
        l10n.dailyWelcomeMessage,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF5B6A5D),
          fontSize: 16,
          height: 1.35,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF5E8B65),
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonOk),
        ),
      ],
    );
  }
}