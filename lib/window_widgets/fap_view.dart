import 'package:clean_path/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/providers/fap_provider.dart';
import '/widgets/Timer_Widget.dart';

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
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Obrazek w tle
                  Positioned.fill(
                    child: Image(
                      image: fapProvider.giveWindowImage(),
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Pasek tła od dołu
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 50, // wysokość paska
                        color: Color(0xFFF7F2E8), // albo inny kolor
                    ),
                  ),

                  // Treść
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          width: 300,
                        ),
                        Spacer(),
                        TimerWidget(
                          timerFunction: providerOperation,
                          startCounter: fapProvider.timerTime,
                        ),
                      ],
                    ),
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
