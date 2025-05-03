import 'package:clean_path/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../providers/fap_provider.dart';
import 'Timer_Widget.dart';
class FapView extends StatelessWidget {
  const FapView({super.key});

  @override
  Widget build(BuildContext context) {
    final fapProvider = Provider.of<FapProvider>(context);
    void providerOperation(int option)
    {
      switch (option)
      {
      case 1://włączenie
          {
            if(fapProvider.faprecord==null) {
              fapProvider.createNewRecord(addictionTypes.fap);
            }
            break;
      }
      case 2://reset timera
          {
            if(fapProvider.faprecord!=null)
              {
                fapProvider.resetTimer();
              }
break;
      }

      }
    }
    return FutureBuilder(
      future: fapProvider.provideData(),
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
                const SizedBox(
                  height: 100,
                  width: 300,
                  child: Text(
                    "Stop Pornography with us Today !",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 50),
                TimerWidget(timerFunction: providerOperation, startCounter: fapProvider.timerTime,),
              ],
            ),
          );
        }
      },
    );

  }

}
