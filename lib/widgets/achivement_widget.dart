import 'package:flutter/material.dart';

import '../data_types/achievement_record.dart';
class AchivementWidget extends StatelessWidget {
  final AchievementRecord record;
  const AchivementWidget({Key? key, required this.record }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(Icons.emoji_events),


    )
    
    
    );
  }
}
