// ignore_for_file: use_build_context_synchronously

import 'package:chatapp/pages/register.dart';
import 'package:chatapp/settings/filebasehelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  Service service = Service();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: (Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Login RONT',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: TextField(
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Enter your Password',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.redAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 100, vertical: 10)),
                  onPressed: () async {
                    final pref = await SharedPreferences.getInstance();

                    if (emailcontroller.text.isNotEmpty &&
                        passwordcontroller.text.isNotEmpty) {
                      service.loginuser(context, emailcontroller.text,
                          passwordcontroller.text);
                      pref.setString("email", emailcontroller.text);
                    } else {
                      service.errorMessage(
                          context, "Please fill all the fields");
                    }
                  },
                  child: Text('Login', style: TextStyle(fontSize: 20)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegisterPage()));
                    },
                    child: Text(
                      'Do not have account?',
                    ))
              ],
            )),
          ),
        ));
  }
}
