import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../screens/home.dart';
import '../screens/settings.dart';
import '../screens/homePage.dart';
import '../model/todo.dart';

class NewAnimatedButton extends StatefulWidget {
  //const NewAnimatedButton({super.key});
  final int? pageType;

  const NewAnimatedButton({
    super.key,
    this.pageType,
  });

  @override
  State<NewAnimatedButton> createState() => _NewAnimatedButtonState();
}

class _NewAnimatedButtonState extends State<NewAnimatedButton> {
  String txt = "";

  @override
  void initState() {
    super.initState();
    switch (widget.pageType!) {
      case 0:
        txt = "My To-Do List";
        break;
      case 1:
        txt = "Settings";
        break;
      case 2:
        txt = "Save and Return";
        break;
    }
  }

  void navigateToToDoPage() {
    final route = MaterialPageRoute(
      builder: (counter) => Home(),
    );
    Navigator.push(context, route).then((_) {
      firstOpening = false;
    });
  }

  void navigateToSettingsPage() {
    final route = MaterialPageRoute(
      builder: (counter) => Settings(),
    );
    Navigator.push(context, route).then((_) {});
  }

  void navigateToBackSaveAndReturn() {
    final route = MaterialPageRoute(
      builder: (counter) => HomePage(),
    );
    Navigator.push(context, route).then((_) {});
  }

  void navigateToBackReturn() {
    final route = MaterialPageRoute(
      builder: (counter) => HomePage(),
    );
    Navigator.push(context, route).then((_) {});
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => {

              
              if (widget.pageType! == 0)
                {navigateToToDoPage()}
              else if (widget.pageType! == 1)
                {navigateToSettingsPage()}
              else if (widget.pageType! == 2)
                {navigateToBackSaveAndReturn()}
              else if (widget.pageType! == 3)
                {navigateToBackReturn()}
            },
        child: Container(
          height: 50,
          width: 160,
          child: Center(
            child: Text(
              txt,
              style: TextStyle(color: tdBlack, fontWeight: FontWeight.w500),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.amberAccent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // darker shadow on bottom right
                color: tdBlack,
                offset: Offset(6, 6),
                blurRadius: 15,
                spreadRadius: 1,
              ),
              BoxShadow(
                // lighter shadow on top left
                color: Colors.white,
                offset: Offset(-6, -6),
                blurRadius: 15,
                spreadRadius: 1,
              ),
            ],
          ),
        ));
  }
}
