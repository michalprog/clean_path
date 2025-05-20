import 'package:flutter/material.dart';

class StatisticListTile extends StatelessWidget {
  final String mainText;
  final String highlightedText;
  final int typ;

  const StatisticListTile({
    Key? key,
    required this.mainText,
    required this.highlightedText,
    this.typ = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color highlightColor;

    // Możesz dostosować styl w zależności od typu
    switch (typ) {
      case 1:
        highlightColor = Colors.green;
        break;
      case 2:
        highlightColor = Colors.red;
        break;
      default:
        highlightColor = Colors.blue;
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(mainText),
        trailing: Text(
          highlightedText,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: highlightColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

