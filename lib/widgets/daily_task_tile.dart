import 'package:flutter/material.dart';

class DailyTaskTile extends StatelessWidget {
  const DailyTaskTile({
    super.key,
    required this.taskIcon,
    required this.taskTitle,
    required this.isCompleted,
    required this.onCompleted,
  });

  final Icon taskIcon;
  final String taskTitle;
  final bool isCompleted;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: taskIcon,
      title: Text(taskTitle),
      subtitle: Text(isCompleted ? 'Wykonane' : 'Nie wykonane'),
      trailing: Checkbox(
        value: isCompleted,
        onChanged: isCompleted
            ? null
            : (value) {
          if (value == true) {
            onCompleted();
          }
        },
      ),
    );
  }
}