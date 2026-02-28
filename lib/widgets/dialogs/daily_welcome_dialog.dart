import 'package:flutter/material.dart';
import '/l10n/app_localizations.dart';

class DailyWelcomeDialog extends StatelessWidget {
  const DailyWelcomeDialog({super.key});

  String _resolveMotivationText(AppLocalizations l10n) {
    final motivationTexts = [
      l10n.dailyWelcomeMotivation1,
      l10n.dailyWelcomeMotivation2,
      l10n.dailyWelcomeMotivation3,
      l10n.dailyWelcomeMotivation4,
    ];

    final now = DateTime.now();
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    final dayIndex = dayOfYear % motivationTexts.length;

    return motivationTexts[dayIndex];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const bg = Color(0xFFF4FBF6);
    const border = Color(0xFFE2EEE6);

    const titleColor = Color(0xFF203A28);
    const accent = Color(0xFF2D6A3D);

    const buttonBg = Color(0xFF5E8B65);

    return AlertDialog(
      alignment: Alignment.center,
      scrollable: true,
      backgroundColor: bg,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
        side: const BorderSide(color: border, width: 1),
      ),
      titlePadding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
      contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
      actionsPadding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFD6EBDD), Color(0xFFBFE0C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x22000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.waving_hand_rounded, color: titleColor, size: 30),
          ),
          const SizedBox(height: 14),
          Text(
            l10n.dailyWelcomeTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w800,
              fontSize: 24,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _resolveMotivationText(l10n),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: accent,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: buttonBg,
            foregroundColor: Colors.white,
            minimumSize: const Size(160, 48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          onPressed: () => Navigator.of(context).pop(),
          label: Text(l10n.dailyWelcomeButton),
        ),
      ],
    );
  }
}