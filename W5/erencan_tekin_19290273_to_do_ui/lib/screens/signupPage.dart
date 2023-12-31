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
  TextEditingController emailController = TextEditingController();
  bool isHidden = false;

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

  Future<String> controlAndProceed() async {
    if (usernameController.text != "" &&
        passwordController.text != "" &&
        emailController.text != "") {
      if (usernameController.text.length < 5 ||
          usernameController.text.length > 25 ||
          passwordController.text.length < 5 ||
          passwordController.text.length > 25) {
        showSnackBar(false,
            "Username and Password length should be in between 5 adn 25.");
        return "";
      }
      /*if (!emailController.text.contains('@')) {
        showSnackBar(false, "Invalid email, it should contain '@' !");
        return "";
      }*/
      final usernameText = usernameController.text;
      final passwordText = passwordController.text;
      final emailText = emailController.text;

      final docTodo = FirebaseFirestore.instance.collection('users').doc();

      Users user = new Users(
          userID: "1",
          usernameText: usernameText,
          passwordText: passwordText,
          emailText: emailText);
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
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.multiline,
                      controller: emailController,
                    ),
                  ),
                  
                ],
              ),
            ),
            SizedBox(height: 30,),
            Row(
              children: [
                SizedBox(width: 50,),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: () {
                    controlAndProceed();
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

            /*Container(
              height: MediaQuery.of(context).size.height * .178,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("lib/images/bottomImage.png"),
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
