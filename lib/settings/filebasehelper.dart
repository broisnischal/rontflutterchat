import 'package:chatapp/pages/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../pages/login.dart';

class Service {
  final FirebaseAuth auth = FirebaseAuth.instance;

  void createUser(context, email, password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()))
              });
    } catch (e) {
      errorMessage(context, e);
    }
  }

  void loginuser(context, email, password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ChatScreen()))
              });
    } catch (e) {
      errorMessage(context, e);
    }
  }

  void logoutuser(context) async {
    try {
      await auth.signOut().then((value) => {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false)
          });
    } catch (e) {
      errorMessage(context, e);
    }
  }

  void errorMessage(context, e) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            // actions: <Widget>[
            //   FlatButton(
            //     child: Text('OK'),
            //     onPressed: () {
            //       Navigator.of(context).pop();
            //     },
            //   )
            // ],
          );
        });
  }
}
