import 'dart:convert';
import 'package:erencan_tekin_19290273_to_do_ui/model/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:animated_background/animated_background.dart';

class addPage extends StatefulWidget {
  const addPage({super.key});

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> with TickerProviderStateMixin{
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int selectedPriority = 0;

  Future<void> submitTasks() async {
    final titleText = titleController.text;
    final descriptionText = descriptionController.text;

    final body = {
      "title": titleText,
      "description": descriptionText,
      "priority": selectedPriority,
    };

    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      titleController.text = '';
      descriptionController.text = '';
      print('Success');
      showSnackBar(true);
    } else {
      print('Error');
      showSnackBar(false);
    }
    print(response.body);
  }

  void showSnackBar(bool isSuccess) {
    Color c;
    c = isSuccess ? Colors.green : Colors.red;
    String message = isSuccess ? "Post is Successful !" : "Post is Fail !";

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
          'Add Page',
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
              decoration: InputDecoration(hintText: 'Title'),
              controller: titleController,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(hintText: 'Description'),
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
                print(selectedPriority.toString());
                submitTasks();
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
