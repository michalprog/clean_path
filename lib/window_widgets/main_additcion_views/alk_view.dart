import 'package:clean_path/widgets/main_addictions_widgets/Timer_Widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/enums/enums.dart';
import '/providers/alcochol_provider.dart';


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
          final screenHeight = MediaQuery.of(context).size.height;
          return Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: alcocholProvider.giveWindowImage(),
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
                      startCounter: alcocholProvider.timerTime,
                      addictionType: AddictionTypes.sweets,
                      recordActivated: alcocholProvider.alcRecord?.activated,
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
