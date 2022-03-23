import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/widgets/MessagesStream.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
User loggedInUser;
final token = _auth.currentUser.getIdToken(true);

final messageStream = _firestore.collection("messages").orderBy('time').snapshots();
DateTime now = DateTime.now();

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextEdittingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUsre();
    getTime();
  }

  void getTime() {
    now = DateTime.now();
  }

  void getCurrentUsre() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  void messageStrem() async {
    await for (var snapshot in _firestore.collection('messages').snapshots()) {
      for (var message in snapshot.docs.reversed) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('token');
                await _auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              messageStream,
              scrollController: scrollController,
              loggedInUser: loggedInUser.email,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextEdittingController,
                      onChanged: (value) {
                        if (value != null) {
                          messageText = value;
                          value = null;
                        }
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      getTime();
                      await _firestore.collection("messages").add({'sender': loggedInUser.email, 'text': messageText, 'time': now});
                      messageTextEdittingController.clear();
                      setState(() {});

                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
