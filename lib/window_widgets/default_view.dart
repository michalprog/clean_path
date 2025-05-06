import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/enums/enums.dart';
import '/providers/sweets_provider.dart';
import '/widgets/Timer_Widget.dart';

class DefaultView extends StatelessWidget {
  const DefaultView({super.key});

  @override
  Widget build(BuildContext context) {
    final sweetsProvider = Provider.of<SweetsProvider>(context);
    void providerOperation(int option) {
      switch (option) {
        case 1: //włączenie
          {
            if (sweetsProvider.sweetRecord == null) {
              sweetsProvider.createNewRecord(addictionTypes.sweets);
            }
            break;
          }
        case 2: //reset timera
          {
            if (sweetsProvider.sweetRecord != null) {
              sweetsProvider.resetTimer();
              sweetsProvider.showPopUp(context);
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
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: sweetsProvider.giveWindowImage(),
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
                      sweetsProvider.getMotivationMsg(),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  TimerWidget(
                    timerFunction: providerOperation,
                    startCounter: sweetsProvider.timerTime,
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
