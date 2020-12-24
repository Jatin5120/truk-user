import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:trukapp/screens/carousel.dart';
import 'package:trukapp/screens/home.dart';
import 'package:trukapp/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    handleTimer();
  }

  handleTimer() async {
    bool isOld = await SharedPref().isOld();
    bool isLogin = await SharedPref().isLoggedIn();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) =>
              !isOld ? CarouselScreen() : (isLogin ? HomeScreen() : Signup()),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Image.asset(
              'assets/images/logo.png',
              height: 80,
            ),
          ),
        ),
      ),
    );
  }
}
