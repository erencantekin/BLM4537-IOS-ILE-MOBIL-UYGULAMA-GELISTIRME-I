import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String userID;
  String usernameText;
  String passwordText;

  Users({
    required this.userID,
    required this.usernameText,
    required this.passwordText,
  });

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'usernameText': usernameText,
        'passwordText': passwordText,
      };

  factory Users.fromSnapshot(DocumentSnapshot snapshot) {
    return Users(
      userID: snapshot['userID'],
      usernameText: snapshot['usernameText'],
      passwordText: snapshot['passwordText'],
    );
  }
}
