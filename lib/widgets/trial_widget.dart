import 'package:flutter/material.dart';
import '/data_types/record.dart';
class TrialWidget extends StatelessWidget {
  final Record record;
  const TrialWidget({Key? key, required this.record }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
title: Text("#id:${record.id}  type:${record.type}"),
        subtitle: Text(""),

      ),
    );
  }
}
