import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:animated_background/animated_background.dart';
import '../model/todo.dart';

class editPage extends StatefulWidget {
  final ToDo? todoItem;

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

  Future<void> updateTask(String id) async {
    final titleText = titleController.text == '' ? widget.todoItem!.todoTitle : titleController.text;
    final descriptionText = descriptionController.text == '' ? widget.todoItem!.todoDescription : descriptionController.text;
    if (titleController.text == widget.todoItem!.todoTitle && descriptionController.text == widget.todoItem!.todoDescription) {
      return; // there is no edit
    }
    
    final body = {
      "title": titleText,
      "description": descriptionText,
      "priority": selectedPriority,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      showSnackBar(true);
    } else {
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
            particleCount: 50,
            minOpacity: 0.1,
            spawnOpacity: 0.2,
            baseColor: animationColor,
          ),
        ),
        vsync: this,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
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
                //print(selectedPriority.toString());
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
