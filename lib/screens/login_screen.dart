import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/widgets/PaddingButtons.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String email, password;
  bool showSpinner = false;

  sharedPref() async {
    final token = await FirebaseAuth.instance.currentUser.getIdToken(true);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 100.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;

                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Email")),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: kTextFieldDecoration.copyWith(hintText: "Enter your Password")),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: kLoginButtonColor,
                onPressed: () async {
                  setState(() {
                    if (email != null || password != null) {
                      showSpinner = true;
                    }
                  });
                  try {
                    final loginUser = await _auth.signInWithEmailAndPassword(email: email, password: password);
                    if (loginUser != null) {
                      sharedPref();
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showSpinner = false;
                      });
                    }
                  } on Exception catch (e) {
                    setState(() {
                      showSpinner = false;
                    });
                    print(e);
                  }
                },
                text: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
