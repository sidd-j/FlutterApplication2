import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterapiapp/Pages/LoginPage.dart';
import 'package:flutterapiapp/ResuableWidgets/ResuableWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapiapp/Config/config.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _passwordConfirmTextController =
      TextEditingController();
  bool _isValid = false;
  bool _passMatch = false;

  late final String errorName;
  final TextEditingController _CountryCode = TextEditingController();

  final TextEditingController _nameTextController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  final Color fieldColor = Color.fromARGB(86, 255, 255, 255);
  final Color bttnColor = Color.fromARGB(255, 255, 255, 255);
  final Color bttnColor2 = Color.fromARGB(0, 254, 254, 254);
  final Color textColor = Color.fromARGB(255, 0, 0, 0);
  final Color textColor2 = Color.fromARGB(255, 255, 254, 254);
  void signUpUser() async {
    if (_passwordTextController.text == _passwordConfirmTextController.text) {
      if (_emailTextController.text.isNotEmpty &&
          _passwordTextController.text.isNotEmpty) {
        var RegisterBody = {
          "email": _emailTextController.text,
          "password": _passwordTextController.text,
          "name": _nameTextController.text,
          "phone_num": _phoneNumberController.text,
          "country": _CountryCode.text
        };
        try {
          var response = await http.post(Uri.parse(registration),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(RegisterBody));
          var responseData = jsonDecode(response.body);
          print(responseData["status"]);
          if (responseData["status"] == true) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginPage()));
          } else {
            errorName = responseData["error"];
          }
        } catch (e) {
          print(errorName);
          InvalidCredentials(errorName);
        }
      } else {
        setState(() {
          _isValid = true;
        });
      }
    } else {
      setState(() {
        _passMatch = true;
      });
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
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("lib/Images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            color: Color.fromARGB(149, 6, 6, 6),
            child: Container(
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              color: Color.fromARGB(125, 1, 0, 0),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  MediaQuery.of(context).size.height * 0,
                  20,
                  20,
                ),
                child: Column(
                  children: <Widget>[
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'Create account',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 251, 251),
                        fontSize: 25,
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      "Enter Full Name",
                      Icons.person_outline,
                      false,
                      _nameTextController,
                      fieldColor,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField("Enter your email", Icons.person_outline,
                        false, _emailTextController, fieldColor,
                        errorText: _isValid ? 'Email cannot be empty' : null,
                        inputType: TextInputType.emailAddress),
                    const SizedBox(
                      height: 30,
                    ),
                    PhoneNumberField(
                      "Enter Phone Number",
                      Icons.phone,
                      false,
                      _phoneNumberController,
                      fieldColor,
                      (Country? country) {
                        if (country != null) {
                          _CountryCode.text = '+' + country.fullCountryCode;
                        }
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      "Enter Password",
                      Icons.lock_outline,
                      true,
                      _passwordTextController,
                      fieldColor,
                      errorText: _isValid ? 'Password cannot be empty' : null,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      "Confirm Password",
                      Icons.lock_outline,
                      true,
                      _passwordConfirmTextController,
                      fieldColor,
                      errorText: _passMatch ? 'Password Not Match' : null,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Text(
                      'I accept the terms and privacy policy',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 251, 251),
                        fontSize: 14,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1.5,
                      ),
                    ),
                    SigninButton(context, false, () {
                      signUpUser();
                    }, "Sign Up", bttnColor, textColor),
                    SigninButton(context, true, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    }, "Already have a Account ? log in", bttnColor2,
                        textColor2)
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
