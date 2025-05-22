import 'package:flutter/material.dart';

class StatisticStateTile extends StatelessWidget {
  final String mainText;
  final bool typeState;
  const StatisticStateTile({
    Key? key,
    required this.mainText, required this.typeState,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(mainText, textAlign: TextAlign.center),
        subtitle: Text(
          typeState ? "active": "not active",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: typeState? Colors.green:Colors.grey,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
