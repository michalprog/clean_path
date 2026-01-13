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
                        image: alcocholProvider.giveWindowImage(),
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
                        startCounter: alcocholProvider.timerTime,
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
