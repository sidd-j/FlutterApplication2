import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterapiapp/Pages/LoginPage.dart';
import 'package:flutterapiapp/Pages/welcome.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SplashScreen extends StatefulWidget {
  final String token; // Declare token as a required parameter
  const SplashScreen({Key? key, required this.token}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward().whenComplete(() {
      // Delay the navigation by 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        if (widget.token == null || widget.token!.isEmpty) {
          // Token is null or empty, navigate to login screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => LoginPage()),
          );
        } else {
          try {
            // Decode the token and check expiration
            if (JwtDecoder.isExpired(widget.token!)) {
              // Token is expired, navigate to login screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => LoginPage()),
              );
            } else {
              // Token is valid, navigate to welcome screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (_) => Welcome(token: widget.token!)),
              );
            }
          } catch (e) {
            // Error decoding token, navigate to login screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => LoginPage()),
            );
          }
        }
      });
    });
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(0, 0, 0, 1),
              Color.fromARGB(255, 0, 0, 0),
              Color.fromARGB(255, 0, 0, 0),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Icon(
              Icons.person,
              size: 200,
              color: Colors.white,
            ),
            FadeTransition(
              opacity: _animation,
            ),
          ],
        ),
      ),
    );
  }
}
