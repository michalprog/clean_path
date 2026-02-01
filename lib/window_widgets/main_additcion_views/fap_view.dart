import 'package:clean_path/enums/enums.dart';
import 'package:clean_path/widgets/main_addictions_widgets/Timer_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/fap_provider.dart';


class FapView extends StatelessWidget {
  const FapView({super.key});

  @override
  Widget build(BuildContext context) {
    final fapProvider = Provider.of<FapProvider>(context);
    void providerOperation(int option) {
      switch (option) {
        case 1: //włączenie
          {
            if (fapProvider.fapRecord == null) {
              fapProvider.createNewRecord(AddictionTypes.fap);
            }
            break;
          }
        case 2: //reset timera
          {
            if (fapProvider.fapRecord != null) {
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
                        image: fapProvider.giveWindowImage(),
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
                        startCounter: fapProvider.timerTime,
                        addictionType: AddictionTypes.fap,
                        recordActivated: fapProvider.fapRecord?.activated,
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
