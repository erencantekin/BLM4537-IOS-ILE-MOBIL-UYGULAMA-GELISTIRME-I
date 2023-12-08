import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../NewAnimatedButton/NewAnimatedButton.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
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
            baseColor: Colors.purpleAccent,
          ),
        ),
        vsync: this,
        child: Center(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("lib/images/headerImage.png"),
                  ),
                ),
              ),
              mainTitle(),
              Container(
                child: Row(
                  children: [
                    SizedBox(width: 12.0),
                    SizedBox(
                      child: Transform.rotate(
                        angle: isJiggling ? 0.1 : -0.1,
                        child: NewAnimatedButton(pageType: 1), // To The Settings Page
                      ),
                    ),
                    SizedBox(width: 50.0),
                    SizedBox(
                      child: Transform.rotate(
                        angle: isJiggling ? 0.1 : -0.1,
                        child: NewAnimatedButton(pageType: 0), // To The To-Do Task Page
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 35.8,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * .25,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("lib/images/bottomImage.png"),
                  ),
                ),
              ),
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

  /*AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: tdBGColor,
      centerTitle: true,
      title: Text(
        "Gotta Do !",
        style: TextStyle(color: tdGrey),
      ),
    );
  }*/
}
