import 'package:erencan_tekin_19290273_to_do_ui/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import '../constants/colors.dart';
import '../constants/fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../NewAnimatedButton/NewAnimatedButton.dart';
import 'dart:async';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


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


  void changeAnimationColor(Color color) { 
    setState(() {
      animationColor = color;
    });
  }
  void changeBackgroundColor(Color color) { 
    setState(() {
      backgroundColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      //appBar: _buildAppBar(),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 25,
            spawnMinSpeed: 5.00,
            particleCount: 50,
            minOpacity: 0.1,
            spawnOpacity: 0.2,
            baseColor: animationColor,
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
                      "Animation Colors",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    animationColorPicker(),
                    Container(),
                    SizedBox(height: 20),
                    Text(
                      "Background Color",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    backgroundColorPicker(),
                  ],
                ),
              ),

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
                        child: NewAnimatedButton(pageType: 2), // Return
                      ),
                    ),
                    SizedBox(width: 50.0),
                    
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

  Widget animationColorPicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Selected Color:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Container(
          width: 50,
          height: 50,
          color: animationColor,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: animationColor,
                      onColorChanged: changeAnimationColor,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Open Color Picker'),
        ),
      ],
    );
  }

  Widget backgroundColorPicker() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Selected Color:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        Container(
          width: 50,
          height: 50,
          color: backgroundColor,
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: ColorPicker(
                      pickerColor: backgroundColor,
                      onColorChanged: changeBackgroundColor,
                      showLabel: true,
                      pickerAreaHeightPercent: 0.8,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: Text('Open Color Picker'),
        ),
      ],
    );
  }
}
