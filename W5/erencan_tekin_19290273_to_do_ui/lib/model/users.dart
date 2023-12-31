import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userID;
  String usernameText;
  String passwordText;
  String emailText;

  Users({
    required this.userID,
    required this.usernameText,
    required this.passwordText,
    required this.emailText,
  });

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'usernameText': usernameText,
        'passwordText': passwordText,
        'emailText': emailText,
      };

  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    return Users(
      userID: snapshot['userID'],
      usernameText: snapshot['usernameText'],
      passwordText: snapshot['passwordText'],
      emailText: snapshot['emailText'],
    );
  }
}
