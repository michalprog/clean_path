import 'package:clean_path/widgets/main_addictions_widgets/Timer_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/enums/enums.dart';
import '/providers/sweets_provider.dart';

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
              sweetsProvider.createNewRecord(AddictionTypes.sweets);
            }
            break;
          }
        case 2: //reset timera
          {
            if (sweetsProvider.sweetRecord != null) {
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
          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: sweetsProvider.giveWindowImage(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: TimerWidget(
                      timerFunction: providerOperation,
                      startCounter: sweetsProvider.timerTime,
                      addictionType: AddictionTypes.sweets,
                      recordActivated: sweetsProvider.sweetRecord?.activated,
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
