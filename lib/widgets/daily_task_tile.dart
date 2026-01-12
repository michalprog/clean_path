import 'package:flutter/material.dart';

class DailyTaskTile extends StatelessWidget {
  const DailyTaskTile({super.key, required this.taskIcon, required this.type, required this.taskTitle, });
final Icon taskIcon;
final int type;// types 0 -nawodnienie 1- workout 3-medytacja 4 -nauka
final String taskTitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
leading: taskIcon,
    );

  }
}
