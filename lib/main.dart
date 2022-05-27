import 'package:chatapp/pages/chat.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/pages/login.dart';
import 'package:chatapp/pages/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

Map<String, WidgetBuilder> routes = {
  // "/": (context) => ChatScreen(),
  "/login": (context) => LoginPage()
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var email = pref.get("email");

  runApp(MaterialApp(
    // initialRoute: "/",
    debugShowCheckedModeBanner: false,
    home: email == null ? LoginPage() : ChatScreen(),
    theme: ThemeData(
      primarySwatch: Colors.red,
    ),
    themeMode: ThemeMode.dark,
    // routes: routes,
  ));
}
