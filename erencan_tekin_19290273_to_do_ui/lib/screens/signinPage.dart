import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:erencan_tekin_19290273_to_do_ui/constants/colors.dart';
import 'package:erencan_tekin_19290273_to_do_ui/model/todo.dart';
import 'package:erencan_tekin_19290273_to_do_ui/model/users.dart';
import 'package:erencan_tekin_19290273_to_do_ui/screens/mainMenu.dart';
import 'package:erencan_tekin_19290273_to_do_ui/screens/signupPage.dart';
import 'package:flutter/material.dart';

class signinPage extends StatefulWidget {
  const signinPage({super.key});

  @override
  State<signinPage> createState() => _signinPageState();
}

class _signinPageState extends State<signinPage> {
  bool isHidden = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void navigateToSignUpPage() {
    final route = MaterialPageRoute(
      builder: (counter) => signupPage(),
    );
    Navigator.push(context, route).then((_) {});
  }

  Future<List<Users>> readUsers() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return querySnapshot.docs.map((doc) => Users.fromSnapshot(doc)).toList();
  }




  @override
  void initState() {
    super.initState();
      setState(() {
        animationColor = Colors.purpleAccent;
        backgroundColor = tdBGColor;
        toDoMainPageCheckedValue = true;
        toDoAddPageCheckedValue = true;
        toDoEditPageCheckedValue = true;
        toDoSettingsPageCheckedValue = true;
        toDoHomePageCheckedValue = true;
      });
  }
  void getUsers() async {
    try {
      List<Users> fetchedUsers = await readUsers();
      bool isInIt = false;
      for (Users user in fetchedUsers) {
        if (user.usernameText == usernameController.text &&
            user.passwordText == passwordController.text) {
            isInIt =true;
          setState(() {
            loggedInUserID = user.userID;
          });
          showSnackBar(true);
          navigateToMainPage();
        }
      }
      if(!isInIt){
        showSnackBar(false);
      }
    } catch (error) {
      print("Could not fetch todos");
    }
  }
  void showSnackBar(bool isSuccess) {
    Color c;
    c = isSuccess ? Colors.green : Colors.red;
    String message = isSuccess ? "Login is Success" : "Login is Fail";

    final snackBar = SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white)),
      backgroundColor: c,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  void navigateToMainPage() {
    final route = MaterialPageRoute(
      builder: (counter) => MainMenu(),
    );
    Navigator.push(context, route).then((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBGColor,
      body: Center(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .30,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/images/headerImage.png"),
                ),
              ),
            ),
            SizedBox(height: 15),
            Container(
              child: Column(
                children: [
                  SizedBox(height: 24.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      obscureText: false,
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
            Row(
              children: [
                SizedBox(width: 90),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    getUsers();
                  },
                  child: Text('Sign In'),
                ),
                SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    navigateToSignUpPage();
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
