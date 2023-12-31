import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erencan_tekin_19290273_to_do_ui/constants/colors.dart';
import 'package:flutter/material.dart';

bool firstOpening =
    true; // to prevent UI crashed during fetching Tasks from API while transition between pages made too fast
Color animationColor = Colors.purpleAccent;
Color backgroundColor = tdBGColor;
bool toDoMainPageCheckedValue = true;
bool toDoAddPageCheckedValue = true;
bool toDoEditPageCheckedValue = true;
bool toDoSettingsPageCheckedValue = true;
bool toDoHomePageCheckedValue = true;
String loggedInUserID = "";


class Todo {
  String id;
  String todoTitle;
  String todoDescription;
  String userID;
  int todoPriority;
  bool isDone;

  Todo({
    required this.id,
    required this.todoTitle,
    required this.todoDescription,
    required this.userID,
    required this.todoPriority,
    this.isDone = false,
  });

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'],
        todoTitle: json['todoTitle'],
        todoDescription: json['todoDescription'],
        userID: json['userID'],
        todoPriority: json['todoPriority'],
        isDone: json['isDone'],
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'todoTitle': todoTitle,
        'todoDescription': todoDescription,
        'userID': userID,
        'todoPriority': todoPriority,
        'isDone': isDone,
      };


      factory Todo.fromSnapshot(DocumentSnapshot snapshot) {
    return Todo(
        id: snapshot['id'],
        todoTitle: snapshot['todoTitle'],
        todoDescription: snapshot['todoDescription'],
        userID: snapshot['userID'],
        todoPriority: snapshot['todoPriority'],
        isDone: snapshot['isDone'],
    );
  }





  
}
