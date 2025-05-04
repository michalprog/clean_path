import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums/enums.dart';
import '../providers/alcochol_provider.dart';
import 'Timer_Widget.dart';

class AlkView extends StatelessWidget {
  const AlkView({super.key});

  @override
  Widget build(BuildContext context) {
    final alcocholProvider = Provider.of<AlcocholProvider>(context);
    void providerOperation(int option) {
      switch (option) {
        case 1: //włączenie
          {
            if (alcocholProvider.alcRecord == null) {
              alcocholProvider.createNewRecord(addictionTypes.alcochol);
            }
            break;
          }
        case 2: //reset timera
          {
            if (alcocholProvider.alcRecord != null) {
              alcocholProvider.resetTimer();
            }
            break;
          }
      }
    }

    return FutureBuilder(
      future: alcocholProvider.provideData(),
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
                    "Stop Drinking Alochol with us Today ",
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                TimerWidget(
                  timerFunction: providerOperation,
                  startCounter: alcocholProvider.timerTime,
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
