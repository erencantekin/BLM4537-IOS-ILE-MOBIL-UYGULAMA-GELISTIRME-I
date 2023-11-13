import 'dart:convert';
import 'package:http/http.dart' as http;

import '../model/todo.dart';
import '../constants/colors.dart';
import 'package:flutter/material.dart';
import '../screens/addPage.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> todosList =[];
  List items = [];

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
    Navigator.push(context, route).then((_){
      setState(() {
        todosList=[];
      });
      fetchAllTasks();
      
    });
  }


  Future<void> fetchAllTasks() async{
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if(response.statusCode == 200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
        final indexCount = items.length;
        for(int i=0;i<indexCount;i++){
          ToDo newTask = ToDo(id: i.toString(),todoTitle: items[i]['title'], todoDescription: items[i]['description'], isDone: false);
          todosList.add(newTask);
        }
        
      });


    }
    else{
      print('fail');
    }
  }

  void handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      appBar: _buildAppBar(),
      body: Container(
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
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Expanded(
                    child: ReorderableListView(
                      children: [
                        for (ToDo todoo in todosList)
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
                              color: Colors.yellow,
                              child: Row(
                                children: [
                                  Text(todoo.todoTitle!,
                                      style: TextStyle(
                                        color: Colors.black,
                                        decoration: todoo.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                      ))
                                ],
                              ),
                            ),
                            subtitle: Text('Priority 1'),
                            trailing: PopupMenuButton(
                              onSelected: (value) {
                                if (value == 'edit') {
                                  // Open Edit Page
                                } else if (value == 'delete') {
                                  // Delete
                                }
                              },
                              itemBuilder: (context) {
                                return [
                                  PopupMenuItem(
                                      child: Text('Edit'), value: 'edit'),
                                  PopupMenuItem(
                                      child: Text('Delete'), value: 'delete')
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
              onPressed: navigateToAddPage,
              label: Text('Add To-Do'),
            ),
          ],
        ),
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: TextField(
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
      backgroundColor: tdBGColor,
      centerTitle: true,
      title: Text(
        "Hello, TO-DO",
        style: TextStyle(color: tdGrey),
      ),
    );
  }
}
