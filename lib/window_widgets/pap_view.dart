import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../enums/enums.dart';
import '../providers/database_provider.dart';
import '../providers/pap_provider.dart';
import 'Timer_Widget.dart';
class PapView extends StatelessWidget {
  const PapView({super.key});

  @override
  Widget build(BuildContext context) {
    final papProvider = Provider.of<PapProvider>(context);
    void providerOperation(int option)
    {
      switch (option)
      {
        case 1://włączenie
          {
            if(papProvider.papRecord==null) {
              papProvider.createNewRecord(addictionTypes.smoking);
            }
            break;
          }
        case 2://reset timera
          {
            if(papProvider.papRecord!=null)
            {
              papProvider.resetTimer();
            }
            break;
          }

      }
    }
    return FutureBuilder(
      future: papProvider.provideData(),
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
                    "Stop Smoking with us Today !",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                TimerWidget(timerFunction: providerOperation, startCounter: papProvider.timerTime,),

              ],

            ),
          );
        }
      },
    );
  }
}
