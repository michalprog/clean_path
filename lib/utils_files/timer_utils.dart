import 'dart:math';

import 'package:flutter/material.dart';

class TimerUtils{

  static AssetImage giveTimerImage(int time)
  {
return AssetImage("assets/images/clean_path0.png");



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


}