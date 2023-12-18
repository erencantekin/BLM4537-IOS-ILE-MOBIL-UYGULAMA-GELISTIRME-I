import 'package:erencan_tekin_19290273_to_do_ui/constants/colors.dart';
import 'package:flutter/material.dart';

bool firstOpening = true; // to prevent UI crashed during fetching Tasks from API while transition between pages made too fast
Color animationColor = Colors.purpleAccent;
Color backgroundColor = tdBGColor;
class ToDo{
  String? id;
  String? todoTitle;
  String? todoDescription;
  //int todoPriority;
  bool isDone;

  ToDo({
    required this.id,
    required this.todoTitle,
    required this.todoDescription,
    //required this.todoPriority,
    this.isDone=false,
  });
}