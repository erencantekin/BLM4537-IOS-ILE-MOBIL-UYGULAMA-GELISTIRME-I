import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import 'package:animated_background/animated_background.dart';
import '../model/todo.dart';

class editPage extends StatefulWidget {
  final Todo? todoItem;

  const editPage({
    super.key,
    this.todoItem,
  });

  @override
  State<editPage> createState() => _editPageState();
}

class _editPageState extends State<editPage> with TickerProviderStateMixin {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int selectedPriority = 0;

  

  Future updateTask(String id) async {
    try {
      final titleText = titleController.text == ''
          ? widget.todoItem!.todoTitle
          : titleController.text;
      final titleDescription = descriptionController.text == ''
          ? widget.todoItem!.todoDescription
          : descriptionController.text;
      final todoPriority = selectedPriority;
      final todoIsDone = false;

      final docTodo = FirebaseFirestore.instance.collection('todo').doc(id);
      Todo todo = new Todo(
        id: id,
        todoTitle: titleText.toString(),
        todoDescription: titleDescription.toString(),
        userID: loggedInUserID,
        todoPriority: todoPriority,
        isDone: todoIsDone,
      );
      await docTodo.update(todo.toJson());
      showSnackBar(true);
    } catch (error) {
      showSnackBar(false);
    }
  }

  void showSnackBar(bool isSuccess) {
    Color c;
    c = isSuccess ? Colors.green : Colors.red;
    String message = isSuccess ? "Edit is Successful !" : "Edit is Fail !";

    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  void initState() {
    super.initState();
    selectedPriority = widget.todoItem!.todoPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: tdGrey),
        backgroundColor: tdBGColor,
        title: Text(
          'Edit Page',
          style: TextStyle(color: tdGrey),
        ),
      ),
      backgroundColor: backgroundColor,
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            spawnMaxRadius: 25,
            spawnMinSpeed: 5.00,
            particleCount: toDoEditPageCheckedValue ? 50 : 0,
            minOpacity: 0.1,
            spawnOpacity: 0.2,
            baseColor: animationColor,
          ),
        ),
        vsync: this,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Row(
                children: [
                  Text(
                    "Animation " + (toDoEditPageCheckedValue ? "On" : "Off"),
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        backgroundColor: animationColor.withOpacity(0.5)),
                  ),
                  Checkbox(
                    value: toDoEditPageCheckedValue,
                    onChanged: (bool? newValue) {
                      setState(() {
                        toDoEditPageCheckedValue = newValue!;
                      });
                    },
                  ),
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: widget.todoItem!.todoTitle.toString(),
              ),
              controller: titleController,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: widget.todoItem!.todoDescription.toString(),
              ),
              minLines: 5,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              controller: descriptionController,
            ),
            SizedBox(height: 40),
            Text("Set Priority"),
            RadioListTile(
              value: 0,
              groupValue: selectedPriority,
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
              title: Text('MAX Priority'),
            ),
            RadioListTile(
              value: 1,
              groupValue: selectedPriority,
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
              title: Text('AVG Priority'),
            ),
            RadioListTile(
              value: 2,
              groupValue: selectedPriority,
              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
              title: Text('MIN Priority'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              onPressed: () {
                updateTask(widget.todoItem!.id.toString());
                print(widget.todoItem!.id.toString());
              },
              child: Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
