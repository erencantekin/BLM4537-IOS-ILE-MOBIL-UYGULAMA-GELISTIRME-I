import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class addPage extends StatefulWidget {
  const addPage({super.key});

  @override
  State<addPage> createState() => _addPageState();
}

class _addPageState extends State<addPage> {
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
      showSnackBar(true, "Post is Successful !");
    } else {
      print('Error');
      showSnackBar(false, "Post is Fail !");
    }
    print(response.body);
  }

  void showSnackBar(bool isSuccess, String message) {
    Color c;
    if(isSuccess){
      c = Colors.green;
    }
    else{
      c = Colors.red;
    }
    final snackBar = SnackBar(
      content: Text(message, style:TextStyle(color: Colors.white)),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Page'),
      ),
      body: ListView(
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
            onPressed: () {
              print(selectedPriority.toString());
              submitTasks();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
