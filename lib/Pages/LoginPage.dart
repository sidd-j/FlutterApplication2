import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapiapp/Pages/RegisterPage.dart';
import 'package:flutterapiapp/Pages/welcome.dart';
import 'package:flutterapiapp/ResuableWidgets/ResuableWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapiapp/Config/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  Color fieldColor = Color.fromARGB(255, 1, 1, 1).withOpacity(0.4);
  Color bttnColor = Color.fromARGB(255, 235, 235, 235);
  Color bttnColor2 = Color.fromARGB(0, 254, 254, 254);
  Color textColor = Color.fromARGB(255, 0, 0, 0);
  Color textColor2 = Color.fromARGB(255, 255, 254, 254);
  bool _usValid = false;
  late SharedPreferences prefes;
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefes = await SharedPreferences.getInstance();
  }

  void LoginUser() async {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      var reqBody = {
        "email": _emailTextController.text,
        "password": _passwordTextController.text
      };
      var response = await http.post(Uri.parse(login),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(reqBody));
      var jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status']) {
        var myToken = jsonResponse['token'];
        prefes.setString('token', myToken);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Welcome(token: myToken)));
      } else {
        if (jsonResponse['error'] == "Password Invalid!!!") {
          // Show password error message to the user
          InvalidCredentials("Invalid Email Password");
        } else if (jsonResponse['error'] == "User Does not exist") {
          // Handle invalid email address
          InvalidCredentials("Invalid Email Email Address");
        } else {
          // Handle other errors
          InvalidCredentials("Something went wrong !!");
        }
      }
    }
  }

  InvalidCredentials(String errorText) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login Failed'),
          
          content: Text(errorText),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("lib/Images/background.jpg"),
                  fit: BoxFit.cover)),
          child: Container(
              color: Color.fromARGB(133, 0, 0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.3, 20, 20),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField("Enter Username", Icons.person_outline,
                        false, _emailTextController, fieldColor),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField("Enter Password", Icons.lock_outline, true,
                        _passwordTextController, fieldColor),
                    const SizedBox(
                      height: 30,
                    ),
                    SigninButton(context, true, () {
                      LoginUser();
                    }, "Login", bttnColor, textColor),
                    const SizedBox(
                      height: 30,
                    ),
                    SigninButton(context, true, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterPage()),
                      );
                    }, "Dont have a Account create one?", bttnColor2,
                        textColor2)
                  ],
                ),
              ))),
    ));
  }
}
