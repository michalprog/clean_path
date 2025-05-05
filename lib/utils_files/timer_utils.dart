import 'dart:math';

import 'package:flutter/material.dart';

class TimerUtils{

  static AssetImage giveTimerImage(int time)
  {
    int days = time ~/ 86400000;

    int imageIndex;

    if (days >= 30) {
      imageIndex = 5;
    } else if (days >= 14) {
      imageIndex = 4;
    } else if (days >= 7) {
      imageIndex = 3;
    } else if (days >= 3) {
      imageIndex = 2;
    } else if (days >= 1) {
      imageIndex = 1;
    } else {
      imageIndex = 0;
    }

    return AssetImage("assets/images/clean_path$imageIndex.png");


  }
static String giveMotivationMessage()
{
  const List<String> motivationMsg=
      [
        "One day at a time — that's enough.",
        "You don’t have to be perfect, just persistent.",
        "Every no is a step toward freedom.",
        "Your strength is built in silence — keep going.",
        "A setback doesn’t erase your progress. Getting back up proves your power.",
        "You are not alone. What you feel matters.",
        "Your tomorrow depends on the choices you make today.",
        "Recovery isn’t weakness. It’s a sign of courage.",
        "Peace in your mind is possible — and it’s worth the fight.",
        "Every day clean is a victory no one can take from you.",
      ];
  var numberMsg = Random().nextInt(9);
  return motivationMsg[numberMsg];
}

  static void showMotivationPopup(BuildContext context) {
    final quote=giveMotivationMessage();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFFEFF3E0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.build,
                  color: Color(0xFF6B8E23),
                  size: 60,
                ),
                const SizedBox(height: 20),
                Text(
                  "You can always begin again. \n Don't lose faith in yourself",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Color(0xFF3B5E3B),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8E23),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Not Now'),
                    ),
                    Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6B8E23),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}