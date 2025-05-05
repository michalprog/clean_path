import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../enums/enums.dart';
import '../providers/pap_provider.dart';
import 'Timer_Widget.dart';

class PapView extends StatelessWidget {
  const PapView({super.key});

  @override
  Widget build(BuildContext context) {
    final papProvider = Provider.of<PapProvider>(context);
    void providerOperation(int option) {
      switch (option) {
        case 1: //włączenie
          {
            if (papProvider.papRecord == null) {
              papProvider.createNewRecord(addictionTypes.smoking);
            }
            break;
          }
        case 2: //reset timera
          {
            if (papProvider.papRecord != null) {
              papProvider.resetTimer();
              papProvider.showPopUp(context);
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
          return Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: papProvider.giveWindowImage(),
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
                      papProvider.getMotivationMsg(),
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                  TimerWidget(
                    timerFunction: providerOperation,
                    startCounter: papProvider.timerTime,
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
