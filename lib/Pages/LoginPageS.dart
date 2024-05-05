import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterapiapp/Config/config.dart';
import 'package:flutterapiapp/Pages/ForgotPassword.dart';
import 'package:flutterapiapp/Pages/verifyEmail.dart';
import 'package:flutterapiapp/Pages/welcome.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences prefes;
  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  bool isSignIn = true;
  bool _usValid = false;
  late final String errorName;

  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _CountryCode = TextEditingController();

  //Add Backend code here!!

  void initSharedPref() async {
    prefes = await SharedPreferences.getInstance();
  }

  void signInFunction() async {
    try {
      if (_emailTextController.text.isNotEmpty &&
          _passwordTextController.text.isNotEmpty) {
        var reqBody = {
          "email": _emailTextController.text,
          "password": _passwordTextController.text
        };
        var response = await http.post(Uri.parse(login),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(reqBody));
        print(response.body);
        var jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status']) {
          var myToken = jsonResponse['token'];
          prefes.setString('token', myToken);
          print("Logged in ");
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
    } catch (e) {
      print("Error signing in: $e");
      // Handle error, show error message to the user, etc.
      InvalidCredentials("Error Signing in");
    }
  }

  void signUpFunction() async {
    if (_passwordTextController.text == _confirmPasswordController.text) {
      if (_emailTextController.text.isNotEmpty &&
          _passwordTextController.text.isNotEmpty) {
        var RegisterBody = {
          "email": _emailTextController.text,
          "password": _passwordTextController.text,
          "name": _fullNameController.text,
          "phone_num": _mobileNumberController.text,
          "country": _CountryCode.text
        };
        try {
          var response = await http.post(Uri.parse(registration),
              headers: {"Content-Type": "application/json"},
              body: jsonEncode(RegisterBody));
          var responseData = jsonDecode(response.body);
          print(responseData["status"]);
          if (responseData["status"] == true) {
            InvalidCredentials("Registeration Sucessfull");

            Navigator.push(context,
                MaterialPageRoute(builder: (context) => VerifyEmail()));
          } else {
            errorName = responseData["error"];
          }
        } catch (e) {
          print(errorName);
          InvalidCredentials(errorName);
        }
      } else {
        print("is not Valid");
      }
    } else {
      print("password not match ");
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

  void toggleSignIn() {
    setState(() {
      isSignIn = !isSignIn;
      _emailTextController.clear();
      _passwordTextController.clear();
      _fullNameController.clear();
      _confirmPasswordController.clear();
      _mobileNumberController.clear();
      _usValid = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(color: Colors.black),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => toggleSignIn(),
                        child: Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: isSignIn
                                ? Theme.of(context).hintColor
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      InkWell(
                        onTap: () => toggleSignIn(),
                        child: Text(
                          'SIGN UP',
                          style: TextStyle(
                            color: !isSignIn
                                ? Theme.of(context).hintColor
                                : Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  if (isSignIn)
                    TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (isSignIn)
                    TextFormField(
                      controller: _passwordTextController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                  if (!isSignIn)
                    SizedBox(height: 20), // Added space for sign up
                  if (!isSignIn)
                    TextFormField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (!isSignIn)
                    TextFormField(
                      controller: _emailTextController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                  SizedBox(height: 10),
                  if (!isSignIn)
                    IntlPhoneField(
                      controller: _mobileNumberController,
                      flagsButtonPadding: const EdgeInsets.all(8),
                      dropdownIconPosition: IconPosition.trailing,
                      decoration: const InputDecoration(
                        labelText: 'Mobile Number',
                        counterText: '',
                      ),
                      initialCountryCode: 'IN',
                      onChanged: (phone) {
                        print(phone.completeNumber);
                      },
                    ),
                  if (!isSignIn)
                    TextFormField(
                      controller: _passwordTextController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                  if (!isSignIn) SizedBox(height: 10),
                  if (!isSignIn)
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                    ),
                  SizedBox(height: 20),
                  if (!isSignIn)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                          value: _usValid,
                          onChanged: (value) {
                            setState(() {
                              _usValid = value ?? false;
                            });
                          },
                          checkColor: Colors.white,
                          activeColor: Theme.of(context).hintColor,
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Accept Terms and Conditions.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors
                                      .blue, // Change the color to indicate it's a link
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // Handle the tap event here, e.g., open a URL
                                    launch('https://www.google.com');
                                  },
                              ),
                              TextSpan(
                                text: '.',
                                style: TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (isSignIn) {
                        // Call function for signing in
                        signInFunction();
                      } else {
                        // Call function for signing up
                        signUpFunction();
                      }
                    },
                    child: Text(isSignIn ? 'SIGN IN' : 'SIGN UP'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                  ),

                  if (isSignIn)
                    TextButton(
                      onPressed: () {
                        // Call function for signing up
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPassword()),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: Theme.of(context).hintColor),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
