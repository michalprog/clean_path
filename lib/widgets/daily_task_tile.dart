import 'package:flutter/material.dart';

import '../enums/enums.dart';



class DailyTaskTile extends StatefulWidget {
  const DailyTaskTile({
    super.key,
    required this.taskIcon,
    required this.type,
    required this.taskTitle,
  });

  final Icon taskIcon;
  final DailyTaskType type;
  final String taskTitle;

  @override
  State<DailyTaskTile> createState() => _DailyTaskTileState();
}

class _DailyTaskTileState extends State<DailyTaskTile> {
  bool checked = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.taskIcon,
      title: Text(widget.taskTitle),
      trailing: Checkbox(
        value: checked,
        onChanged: (value) {
          setState(() {
            checked = value ?? false;
          });
        },
      ),
    );
  }
}
