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
    void providerOperation(int option) {
      switch (option) {
        case 1: //włączenie
          {
            if (fapProvider.fapRecord == null) {
              fapProvider.createNewRecord(addictionTypes.fap);
            }
            break;
          }
        case 2: //reset timera
          {
            if (fapProvider.fapRecord != null) {
              fapProvider.resetTimer();
              fapProvider.showPopUp(context);
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
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: fapProvider.giveWindowImage(),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   SizedBox(
                    height: 100,
                    width: 300,
                    child: Text(
                      fapProvider.getMotivationMsg(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(height: 100),
                  TimerWidget(
                    timerFunction: providerOperation,
                    startCounter: fapProvider.timerTime,
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
