import 'dart:async';
import 'package:erencan_tekin_19290273_to_do_ui/screens/signinPage.dart';

import '../model/todo.dart';
import '../constants/colors.dart';
import 'package:flutter/material.dart';
import '../screens/addPage.dart';
import '../screens/editPage.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Todo> todosList = [];
  List items = [];
  List<Todo> foundToDo = [];

  void updateMyList(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final todoo = todosList.removeAt(oldIndex);
      todosList.insert(newIndex, todoo);
    });
  }

  void navigateToAddPage() {
    final route = MaterialPageRoute(
      builder: (counter) => addPage(),
    );
    Navigator.push(context, route).then((_) {
      GetTodos();
    });
  }

  void navigateToLogOut() {
    final route = MaterialPageRoute(
      builder: (counter) => signinPage(),
    );
    Navigator.push(context, route).then((_) {
      GetTodos();
    });
  }

  void navigateToEditPage(Todo item) {
    final route = MaterialPageRoute(
      builder: (counter) => editPage(todoItem: item),
    );
    Navigator.push(context, route).then((_) {
      GetTodos();
    });
  }

  

  void showSnackBar(bool isSuccess, String operation) {
    Color c;
    c = isSuccess ? Colors.green : Colors.red;
    String message =
        isSuccess ? "$operation is Successful !" : "$operation is Fail !";

    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void handleToDoChange(Todo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  static StreamTransformer transformer<T>(
          T Function(Map<String, dynamic> json) fromJson) =>
      StreamTransformer<QuerySnapshot, List<T>>.fromHandlers(
        handleData: (QuerySnapshot data, EventSink<List<T>> sink) {
          final snaps = data.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();
          final objects = snaps.map((json) => fromJson(json)).toList();
          sink.add(objects);
        },
      );


  @override
  void initState() {
    super.initState();
    firstOpening = true;
    GetTodos();
  }

  void GetTodos() async {
    try {
      if (firstOpening) {
        List<Todo> fetchedTodos = await readTodos();
        setState(() {
          todosList.clear();
          for (Todo todo in fetchedTodos) {
            if (todo.userID == loggedInUserID) {
              todosList.add(todo);
            }
          }
          foundToDo = todosList;
        });
      }
    } catch (error) {
      print("Could not fetch todos");
    }
  }

  void filterInUse(String entered) {
    List<Todo> results = [];
    if (entered.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
              item.todoTitle.toLowerCase().contains(entered.toLowerCase()))
          .toList();
    }

    setState(() {
      foundToDo = results;
    });
  }


  Future<List<Todo>> readTodos() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('todo').get();

    return querySnapshot.docs.map((doc) => Todo.fromSnapshot(doc)).toList();
  }

  Future deleteById(String id) async {
    try {
      final docTodo = FirebaseFirestore.instance.collection('todo').doc(id);
      await docTodo.delete();
      GetTodos();
      showSnackBar(true, "Delete");
    } catch (error) {
      showSnackBar(false, "Delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(),
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 25,
            spawnMinSpeed: 5.00,
            particleCount: toDoMainPageCheckedValue ? 50 : 0,
            minOpacity: 0.1,
            spawnOpacity: 0.2,
            baseColor: animationColor,
          ),
        ),
        vsync: this,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Row(
                  children: [
                    Text(
                      "Animation " + (toDoMainPageCheckedValue ? "On" : "Off"),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          backgroundColor: animationColor.withOpacity(0.5)),
                    ),
                    Checkbox(
                      value: toDoMainPageCheckedValue,
                      onChanged: (bool? newValue) {
                        setState(() {
                          toDoMainPageCheckedValue = newValue!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              searchBox(),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50, bottom: 20),
                      child: Text(
                        'My To-Do List',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: ReorderableListView(
                        children: [
                          for (Todo todoo in foundToDo)
                            ListTile(
                              onTap: () {
                                handleToDoChange(todoo);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              tileColor: Colors.white,
                              leading: Icon(todoo.isDone
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank),
                              key: ValueKey(todoo.id),
                              title: Container(
                                color: tdBGColor.withOpacity(0.9),
                                child: Row(
                                  children: [
                                    Text(
                                      todoo.todoTitle.length > 20 ? todoo.todoTitle.substring(0,20) + "..." : todoo.todoTitle,
                                      style: TextStyle(
                                          color: Colors.black,
                                          decoration: todoo.isDone
                                              ? TextDecoration.lineThrough
                                              : null,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),

                              subtitle: Text('Priority ' + (todoo.todoPriority == 0 ? "MIN" : (todoo.todoPriority  == 1 ? "AVG" : todoo.todoPriority == 2 ? "MAX" : ""))),
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    navigateToEditPage(todoo);
                                  } else if (value == 'delete') {
                                    deleteById(todoo.id);
                                  }
                                },
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: Text('Edit'),
                                      value: 'edit',
                                    ),
                                    PopupMenuItem(
                                      child: Text('Delete'),
                                      value: 'delete',
                                    )
                                  ];
                                },
                              ),
                            ),
                        ],
                        onReorder: (oldIndex, newIndex) =>
                            updateMyList(oldIndex, newIndex),
                      ),
                    ),
                  ],
                ),
              ),
              FloatingActionButton.extended(
                backgroundColor: Colors.amber,
                onPressed: navigateToAddPage,
                label: Text('Add To-Do'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => filterInUse(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: tdBlack,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: tdGrey),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const BackButton(color: tdGrey),
      backgroundColor: tdBGColor,
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
