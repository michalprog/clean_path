import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/enums/enums.dart';
import '/providers/alcochol_provider.dart';
import '/widgets/Timer_Widget.dart';

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
              alcocholProvider.createNewRecord(AddictionTypes.alcochol);
            }
            break;
          }
        case 2: //reset timera
          {
            if (alcocholProvider.alcRecord != null) {
              alcocholProvider.resetTimer();
              alcocholProvider.showPopUp(context);
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
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: alcocholProvider.giveWindowImage(),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    width: 300,
                    child: Text(
                      alcocholProvider.getMotivationMsg(),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  TimerWidget(
                    timerFunction: providerOperation,
                    startCounter: alcocholProvider.timerTime,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
