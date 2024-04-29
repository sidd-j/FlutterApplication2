import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterapiapp/Config/config.dart';
import 'package:flutterapiapp/Pages/LoginPage.dart';
import 'package:flutterapiapp/Pages/editProfile.dart';
import 'package:flutterapiapp/ResuableWidgets/ResuableWidgets.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  }

  void signOutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", "");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> getUserData(email) async {
    try {
      var url = userdata;

      // Send the GET request
      var response = await http.get(Uri.parse(url + '?email=$email'));

      // Check if the request was successful
      if (response.statusCode == 200) {
        // Print the response body (JSON data)
        var UserData = jsonDecode(response.body);
        var userDataJson = UserData['data'];

        // Format the extracted data for display
        var formattedData = '''
        Email: ${userDataJson['email']}
        Name: ${userDataJson['name']}
        Country: ${userDataJson['country']}
        Phone Number: ${userDataJson['phone_num']}
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

  displayUserData() {
    return Text(
      userData ?? '',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontFamily: 'Kanit',
      ),
    );
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/Images/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                10, MediaQuery.of(context).size.height * 0.3, 10, 10),
            color: Color.fromARGB(149, 6, 6, 6),
            height: MediaQuery.of(context).size.height * 1,
            width: MediaQuery.of(context).size.width * 1,
            child: Column(
              children: [
                Text(
                  'Welcome, $email',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
                Text(
                  userData ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: 'Kanit',
                  ),
                ),
                const SizedBox(
                  height: 90,
                ),
                ElevatedButton(
                  onPressed: () {
                    getUserData(email);
                  },
                  child: Text('Get Data'),
                ),
                SigninButton(context, false, () {
                  navto();
                }, "View Profile", bttnColor, textColor)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
