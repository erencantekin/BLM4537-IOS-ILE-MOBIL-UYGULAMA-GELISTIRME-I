import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../NewAnimatedButton/NewAnimatedButton.dart';
import 'dart:async';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with TickerProviderStateMixin {
  bool isJiggling = false;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        isJiggling = !isJiggling;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      //appBar: _buildAppBar(),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            spawnMaxRadius: 25,
            spawnMinSpeed: 5.00,
            particleCount: 50,
            minOpacity: 0.1,
            spawnOpacity: 0.2,
            baseColor: Colors.transparent,
          ),
        ),
        vsync: this,
        child: Center(
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Container(
                  height: MediaQuery.of(context).size.height * .6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("lib/images/page.png"),
                    ),
                  ),
                ),
              ),
              //  mainTitle(),
              Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 250),
                  children: [
                    Text(
                      "Colors",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(),
                    SizedBox(height: 20),
                    Text(
                      "Fonts",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              //mainTitle(),

              Positioned(
                left: 0,
                bottom: 50,
                right: 0,
                child: Row(
                  children: [
                    SizedBox(width: 12.0),
                    SizedBox(
                      child: Transform.rotate(
                        angle: isJiggling ? 0.1 : -0.1,
                        child: NewAnimatedButton(pageType: 3), // Return
                      ),
                    ),
                    SizedBox(width: 50.0),
                    SizedBox(
                      child: Transform.rotate(
                        angle: isJiggling ? 0.1 : -0.1,
                        child: NewAnimatedButton(pageType: 2), // Save & Return
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 50,
                      ),
                    ),
                  ],
                ),
              ),

              /*Container(
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("lib/images/bottomImage.png"),
                  ),
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }

  Widget mainTitle() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 50,
        vertical: 100,
      ),
      child: SizedBox(
        height: 120.0,
        width: MediaQuery.of(context).size.width,
        child: AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              "Your ",
              textStyle: colorizeTextStyle,
              textAlign: TextAlign.center,
              colors: colorizeColors,
            ),
            ColorizeAnimatedText(
              "New",
              textStyle: colorizeTextStyle,
              textAlign: isJiggling ? TextAlign.left : TextAlign.right,
              colors: colorizeColors,
            ),
            ColorizeAnimatedText(
              "Task Holder !",
              textStyle: colorizeTextStyle,
              textAlign: TextAlign.center,
              colors: colorizeColors,
            ),
          ],
          isRepeatingAnimation: true,
          repeatForever: true,
        ),
      ),
    );
  }
}
