import 'package:flutter/material.dart';

import 'Timer_Widget.dart';
class DefaultView extends StatelessWidget {
  const DefaultView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SizedBox(
            height: 100,
            width: 300,
            child: Text(
              "Stop Sweets Addiction with us Today !",
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          TimerWidget(),

        ],

      ),
    );;
  }
}
