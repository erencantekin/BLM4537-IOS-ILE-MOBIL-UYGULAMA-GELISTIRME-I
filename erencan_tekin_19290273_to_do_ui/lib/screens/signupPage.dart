import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/users.dart';
import '../screens/signinPage.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class signupPage extends StatefulWidget {
  const signupPage({super.key});

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isHidden = false;
  bool isAlreadyAvailable = false;

  void navigateToSignInPage() {
    final route = MaterialPageRoute(
      builder: (counter) => signinPage(),
    );
    Navigator.push(context, route).then((_) {});
  }

  void showSnackBar(bool isSuccess, String snackBarText) {
    Color c;
    c = isSuccess ? Colors.green : Colors.red;
    String message = snackBarText;

    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<List<Users>> readUsers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs.map((doc) => Users.fromSnapshot(doc)).toList();
  }

  void getUsers(String username) async {
    try {
      List<Users> fetchedUsers = await readUsers();
      bool isInIt = false;
      for (Users user in fetchedUsers) {
        if (user.usernameText == username) {
          isInIt = true;
          break;
        }
      }
      if (isInIt) {
        isAlreadyAvailable = true;
      }
    } catch (error) {
      print("Could not fetch todos");
    }
  }

  Future<String> controlAndProceed() async {
    
    if (usernameController.text != "" && passwordController.text != "") {
      if (usernameController.text.length < 5 ||
          usernameController.text.length > 25 ||
          passwordController.text.length < 5 ||
          passwordController.text.length > 25) {
        showSnackBar(false,
            "Username and Password length should be in between 5 adn 25.");
        return "";
      }

      final usernameText = usernameController.text;
      final passwordText = passwordController.text;

      getUsers(usernameText);
      if (isAlreadyAvailable) {
        showSnackBar(
            false, "This username is available, please choose another !");
        return "";
      }
      final docTodo = FirebaseFirestore.instance.collection('users').doc();

      Users user = new Users(
          userID: "1", usernameText: usernameText, passwordText: passwordText);
      user.userID = docTodo.id;
      await docTodo.set(user.toJson());

      showSnackBar(true, "New User is successfully created !");
      return docTodo.id;
    } else {
      showSnackBar(false, "Please fill every blank!");
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .25,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/images/headerImage.png"),
                ),
              ),
            ),
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Username'),
                      keyboardType: TextInputType.multiline,
                      controller: usernameController,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      obscureText: !isHidden,
                      decoration: InputDecoration(labelText: 'Password'),
                      keyboardType: TextInputType.multiline,
                      controller: passwordController,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                      ),
                      Text("Show Password"),
                      Checkbox(
                        value: isHidden,
                        onChanged: (bool? newValue) {
                          setState(() {
                            isHidden = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    controlAndProceed();
                    isAlreadyAvailable = false;
                  },
                  child: Text('Sign Up'),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    navigateToSignInPage();
                  },
                  child: Text('Return to Sign In Page'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
