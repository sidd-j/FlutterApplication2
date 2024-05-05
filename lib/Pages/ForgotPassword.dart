import 'package:flutter/material.dart';
import 'package:flutterapiapp/Config/config.dart';
import 'package:flutterapiapp/Pages/LoginPageS.dart';
import 'package:flutterapiapp/Pages/welcome.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _OTPTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  late SharedPreferences prefes;

  void initSharedPref() async {
    prefes = await SharedPreferences.getInstance();
  }

  bool isSignIn = true;

  void toggleSignIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> forgotpassword() async {
    var email = _emailTextController.text;
    var otp = _OTPTextController.text;
    var password = _passwordTextController.text;

    if (_passwordTextController.text != _confirmPasswordController) {
      InvalidCredentials("Passwords do not match");
    }
    var body = {"email": email, "OTP": otp, "password": password};
    try {
      var response = await http.post(Uri.parse(forgotPassword),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));

      print('Request body: $body');
      print('Response body: ${response.body}');

      var jsonResponse = jsonDecode(response.body);
      print(jsonResponse);
      if (jsonResponse['status']) {
        print("Logged in ");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Verification failed, show error message
        InvalidCredentials(jsonResponse["message"]);
      }
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error verifying OTP: $e');
      // Show error message
      InvalidCredentials('Error verifying OTP');
    }
  }

  Future<void> getOtp() async {
    var email = _emailTextController.text;

    var body = {
      "email": email,
    };
    try {
      var response = await http.post(Uri.parse(getOTPforforgotpassword),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body));
      InvalidCredentials("OTP has Been Send to Your email");
    } catch (e) {
      // Handle any errors that occur during the request
      print('Error Sending OTP: $e');
      // Show error message
      InvalidCredentials('Error sending OTP');
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
                          'Forgot Password',
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
                    ],
                  ),
                  SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _emailTextController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Add your logic here to get OTP
                          getOtp();
                        },
                        child: Text('Get OTP'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _OTPTextController,
                    decoration: const InputDecoration(
                      labelText: 'OTP',
                      prefixIcon: Icon(Icons.lock),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordTextController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      forgotpassword();
                    },
                    child: Text('Reset Password'),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Center(
        child: Text('Welcome to the app!'),
      ),
    );
  }
}
