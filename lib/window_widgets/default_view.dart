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
          final screenHeight = MediaQuery.of(context).size.height;
          return Container(
            color: Color(0xFFF7F2E8),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: screenHeight * 0.6,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: sweetsProvider.giveWindowImage(),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
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
                      ),
                    ),
                  ),
                ),
              ],

            ),
          );
        }
      },
    );
  }
}
