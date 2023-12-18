import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/todo.dart';
import '../constants/colors.dart';
import 'package:flutter/material.dart';
import '../screens/addPage.dart';
import '../screens/editPage.dart';
import 'package:animated_background/animated_background.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<ToDo> todosList = [];
  List items = [];
  List<ToDo> foundToDo = [];

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
      fetchAllTasks();
    });
  }

  void navigateToEditPage(ToDo item) {
    final route = MaterialPageRoute(
      builder: (counter) => editPage(todoItem: item),
    );
    Navigator.push(context, route).then((_) {
      fetchAllTasks();
    });
  }

  Future<void> fetchAllTasks() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';//'http://10.0.2.2:7277/api/ToDoTasks';  //127.0.0.1 ya da localhsot yap C# launchSettings.json u
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print("response>:" + response.statusCode.toString());
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      if (firstOpening) {
        setState(
          () {
            todosList.clear();
            items = result;
            final indexCount = items.length;
            for (int i = 0; i < indexCount; i++) {
              ToDo newTask = ToDo(
                id: items[i]['_id'] as String,
                todoTitle: items[i]['title'],
                todoDescription: items[i]['description'],
                isDone: false,
              );

              todosList.add(newTask);
            }
          },
        );
      }
    } else {
      showSnackBar(false, "Fetch");
    }
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      fetchAllTasks();
      showSnackBar(true, "Delete");
    } else {
      showSnackBar(false, "Delete");
    }
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

  void handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  @override
  void initState() {
    super.initState();
    firstOpening = true;
    fetchAllTasks();
    foundToDo = todosList;
  }

  void FilterInUse(String entered) {
    List<ToDo> results = [];
    if (entered.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) =>
              item.todoTitle!.toLowerCase().contains(entered.toLowerCase()))
          .toList();
    }

    setState(() {
      foundToDo = results;
    });
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
            particleCount: 50,
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
                          for (ToDo todoo in foundToDo)
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
                              key: ValueKey(todoo.id!),
                              title: Container(
                                color: tdBGColor.withOpacity(0.5),
                                child: Row(
                                  children: [
                                    Text(
                                      todoo.todoTitle!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: todoo.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              subtitle: Text('Priority 1'),
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    navigateToEditPage(todoo);
                                  } else if (value == 'delete') {
                                    deleteById(todoo.id!);
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
        onChanged: (value) => FilterInUse(value),
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
    );
  }
}
