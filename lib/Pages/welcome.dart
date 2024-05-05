import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapiapp/Config/config.dart';
import 'package:flutterapiapp/Pages/editProfile.dart';
import 'package:flutterapiapp/ResuableWidgets/ResuableWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterapiapp/Pages/LoginPageS.dart';

class Welcome extends StatefulWidget {
  final token;
  const Welcome({Key? key, required this.token}) : super(key: key);
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  late String email;
  final Color fieldColor = Color.fromARGB(86, 255, 255, 255);
  final Color bttnColor = Color.fromARGB(255, 255, 255, 255);
  final Color textColor = Color.fromARGB(255, 0, 0, 0);
  String? userData;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtdecdedToken = JwtDecoder.decode(widget.token);

    email = jwtdecdedToken['email'];
    getUserData(email);
  }

  void signOutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("token", "");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

// Declare userDataJson outside of the method
  Map<String, dynamic>? userDataJson;

  Future<void> getUserData(email) async {
    try {
      // Send the GET request
      var response = await http.get(Uri.parse('$userdata?email=$email'));
      print(url);

      print(response.body);
      if (response.statusCode == 200) {
        var UserData = jsonDecode(response.body);
        userDataJson = UserData['data'];

        // Format the extracted data for display
        var formattedData = '''
      Email: ${userDataJson?['email']}
      Name: ${userDataJson?['name']}
      Country: ${userDataJson?['country']}
      Phone Number: ${userDataJson?['phone_num']}
    ''';

        // Update the userData state variable
        setState(() {
          userData = formattedData;
        });
      }
    } catch (e) {
      // Print any errors that occur during the request
      print('Error: $e');
    }
  }

  navto() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => EditProfile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 0, 0, 0), // Set the background color here

        title: const Text('Home Page',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
        actions: [
          IconButton(
            onPressed: () => signOutUser(context),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(color: Colors.black),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: const BoxDecoration(),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height * 0.1,
                        MediaQuery.of(context).size.height * 0.1,
                        10,
                        20),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 79, 89, 1),
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(50))),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      'Welcome, ${userDataJson?["name"]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: SigninButton(context, false, () {
                      navto();
                    }, "View Profile", bttnColor, textColor),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        MediaQuery.of(context).size.height * 0.1,
                        MediaQuery.of(context).size.height * 0.1,
                        10,
                        20),
                    height: MediaQuery.of(context).size.height,
                    child: Text(
                      'Name : ${userDataJson?["name"]}\nEmail id : ${userDataJson?["email"]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Kanit',
                      ),
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
