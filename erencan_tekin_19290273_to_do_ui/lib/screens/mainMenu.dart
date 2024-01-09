import '../model/todo.dart';
import '../screens/signinPage.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../NewAnimatedButton/NewAnimatedButton.dart';
import 'dart:async';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> with TickerProviderStateMixin {
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

  void navigateToLogOut() {
    final route = MaterialPageRoute(
      builder: (counter) => signinPage(),
    );
    Navigator.push(context, route).then((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 25,
            spawnMinSpeed: 5.00,
            particleCount: toDoHomePageCheckedValue ? 50 : 0,
            minOpacity: 0.1,
            spawnOpacity: 0.2,
            baseColor: animationColor,
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
                padding: EdgeInsets.symmetric(horizontal: 120),
                child: Row(
                  children: [
                    Text(
                      "Animation " + (toDoHomePageCheckedValue ? "On" : "Off"),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          backgroundColor: animationColor.withOpacity(0.5)),
                    ),
                    Checkbox(
                      value: toDoHomePageCheckedValue,
                      onChanged: (bool? newValue) {
                        setState(() {
                          toDoHomePageCheckedValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.0),
              Container(
                child: Row(
                  children: [
                    SizedBox(width: 12.0),
                    SizedBox(
                      child: Transform.rotate(
                        angle: isJiggling ? 0.1 : -0.1,
                        child: NewAnimatedButton(
                            pageType: 1), // To The Settings Page
                      ),
                    ),
                    SizedBox(width: 50.0),
                    SizedBox(
                      child: Transform.rotate(
                        angle: isJiggling ? 0.1 : -0.1,
                        child: NewAnimatedButton(
                            pageType: 0), // To The To-Do Task Page
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

  AppBar _buildAppBar() {
    return AppBar(
      leading: const BackButton(color: tdGrey),
      backgroundColor: Colors.purpleAccent,
      title: Text(
        'My To-Do List',
        style: TextStyle(color: tdGrey),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.logout_rounded),
          color: Colors.black,
          onPressed: () {
            navigateToLogOut();
          },
        ),
      ],
    );
  }
}
