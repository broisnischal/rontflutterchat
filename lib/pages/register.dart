import 'package:chatapp/pages/login.dart';
import 'package:chatapp/settings/filebasehelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                  'Register RONT',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: TextField(
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(10),
                        hintText: 'Register your email',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15)))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 30),
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
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();

                    if (emailcontroller.text.isNotEmpty &&
                        passwordcontroller.text.isNotEmpty) {
                      service.createUser(context, emailcontroller.text,
                          passwordcontroller.text);
                      pref.setString('email', emailcontroller.text);
                    } else {
                      service.errorMessage(
                          context, "Please fill all the fields");
                    }
                  },
                  child: Text('Sign Up', style: TextStyle(fontSize: 20)),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    },
                    child: const Text(
                      'Already have account?',
                    ))
              ],
            )),
          ),
        ));
  }
}
