import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:trukapp/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
    return MaterialApp(
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: primaryColor, elevation: 8.0)),
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
}
