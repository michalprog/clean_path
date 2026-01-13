import 'dart:math';

import 'package:flutter/material.dart';

class TimerUtils{

  static AssetImage giveTimerImage(int time) {
    int days = time ~/ 86400000; // convert ms to days
    int hours = (time ~/ 3600000); // convert ms to hours

    int imageIndex;

    if (hours < 4) {
      imageIndex = 0;
    } else if (hours < 12) {
      imageIndex = 1;
    } else if (days < 1) {
      imageIndex = 2;
    } else if (days < 2) {
      imageIndex = 3;
    } else if (days < 7) {
      imageIndex = 4;
    } else if (days < 14) {
      imageIndex = 5;
    } else if (days < 21) {
      imageIndex = 6;
    } else if (days < 28) {
      imageIndex = 7;
    } else if (days < 42) {
      imageIndex = 8;
    } else if (days < 56) {
      imageIndex = 9;
    } else if (days < 84) {
      imageIndex = 10;
    } else if (days < 112) {
      imageIndex = 11;
    } else if (days < 180) {
      imageIndex = 12;
    } else if (days < 240) {
      imageIndex = 13;
    } else if (days < 270) {
      imageIndex = 14;
    } else if (days < 300) {
      imageIndex = 15;
    } else if (days < 330) {
      imageIndex = 16;
    } else if (days < 365) {
      imageIndex = 17;
    } else {
      imageIndex = 18; // 365 days and beyond
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

  static void showMotivationPopup(
      BuildContext context, {
        required VoidCallback onTryAgain,
      }) {
    final quote=giveMotivationMessage();
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Color(0xFFBFCDB3), Color(0xFF6B8E23)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.sentiment_dissatisfied_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "You can always begin again. \nDon't lose faith in yourself",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
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
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            onTryAgain();
                          });
                        },
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
          ),
        );

      },
    );
  }

}