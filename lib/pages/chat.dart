import 'package:chatapp/pages/contact.dart';
import 'package:chatapp/settings/filebasehelper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

var loginuser = FirebaseAuth.instance.currentUser;

var loginemail = loginuser!.email.toString();

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  Service service = Service();
  final storeMessage = FirebaseFirestore.instance;

  final auth = FirebaseAuth.instance;

  getCurrentuser() {
    final user = auth.currentUser;
    if (user != null) {
      loginuser = user;
      print(loginuser);
    }
  }

  TextEditingController msg = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentuser();
  }

  @override
  Widget build(BuildContext context) {
    double deviceheight = MediaQuery.of(context).size.height / 2 + 100;
    return Scaffold(
        // resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Chat App - RONT'),
          elevation: 0,
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.connectdevelop),
              onPressed: () async {
                const url = "https://neeswebservices.netlify.app/";

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.connect_without_contact),
              onPressed: () async {
                const url = "https://www.instagram.com/neeswebservices/";

                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                service.logoutuser(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
                // Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // displaying messages

                Container(
                    height: deviceheight,
                    child: SingleChildScrollView(
                        physics: ScrollPhysics(),
                        reverse: true,
                        child: Messages())),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    color: Colors.white38,
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: msg,
                            // style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Type a message',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            if (msg.text.isNotEmpty) {
                              storeMessage.collection("messages").doc().set({
                                "msg": msg.text.trim(),
                                "user": loginuser!.email.toString(),
                                "time": DateTime.now(),
                              });
                              msg.clear();
                            }
                          },
                        )
                      ]),
                ),
              ]),
        ));
  }
}

class Messages extends StatefulWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("messages")
            .orderBy("time")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
              physics: ScrollPhysics(),
              itemCount: snapshot.data!.docs.length,
              primary: true,
              shrinkWrap: true,
              itemBuilder: (context, i) {
                QueryDocumentSnapshot x = snapshot.data!.docs[i];
                // print(user);
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: loginuser!.email == x["user"]
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: loginuser!.email == x['user']
                                    ? NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQarxp3w2V2uosNwCyzIp1tILCurA27Wq0tXXjO_xykwjz2aIWKABGd621rpjLWcR3ZGs8&usqp=CAU")
                                    : NetworkImage(
                                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSrCdCZTjOqWF5s1vkeQ0SlUEZLZdk2HtedB0d3zcaF4oVaDbFtS3wy8i0Q_jbh6vTQSk&usqp=CAU"),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 2,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                color: loginuser!.email == x['user']
                                    ? Colors.red.withOpacity(0.2)
                                    : Colors.blue.withOpacity(0.2),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        x["user"],
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      Divider(
                                        color: Colors.black,
                                      ),
                                      Container(child: Text(x["msg"])),
                                    ]),
                              )
                            ])
                      ]),
                );
              });
        });
  }
}
