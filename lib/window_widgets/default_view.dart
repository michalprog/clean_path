import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/enums.dart';
import '../providers/sweets_provider.dart';
import 'Timer_Widget.dart';
class DefaultView extends StatelessWidget {
  const DefaultView({super.key});

  @override
  Widget build(BuildContext context) {

    final sweetsProvider = Provider.of<SweetsProvider>(context);
    void providerOperation(int option)
    {
      switch (option)
      {
        case 1://włączenie
          {
            if(sweetsProvider.sweetRecord==null) {
              sweetsProvider.createNewRecord(addictionTypes.sweets);
            }
            break;
          }
        case 2://reset timera
          {
            if(sweetsProvider.sweetRecord!=null)
            {
              sweetsProvider.resetTimer();
            }
            break;
          }

      }
    }
    return FutureBuilder(
      future: sweetsProvider.provideData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Błąd: ${snapshot.error}"));
        } else {
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
                TimerWidget(timerFunction: providerOperation, startCounter:sweetsProvider.timerTime,),

              ],

            ),
          );
        }
      },
    );


  }
}
