import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Tło
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/main_window_screen.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),


          Positioned(
            top: 40,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: 300,
                  child: Text(
                    "Get rid of addictions with us today !",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),

              ],
            ),
          ),


          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                height: 80,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Horizon',
                    color: Colors.white,
                  ),

                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText("Pornography"),
                      RotateAnimatedText("Smoking"),
                      RotateAnimatedText("Drinking"),
                      RotateAnimatedText("Sweets"),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


}
