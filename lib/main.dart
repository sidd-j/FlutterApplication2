import 'package:flutter/material.dart';
import 'package:flutterapiapp/Pages/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    myToken: prefs.getString('token'),
  ));
}

class MyApp extends StatelessWidget {
  final String? myToken;
  MyApp({
    @required this.myToken,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    precacheImage(const AssetImage("lib/Images/background.jpg"), context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(
        token: myToken ?? '',
      ),
    );
  }
}
