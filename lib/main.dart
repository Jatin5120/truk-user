import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/models/chatting_list_model.dart';
import 'models/user_model.dart';
import 'models/wallet_model.dart';
import 'screens/splash.dart';
import 'package:flutter/material.dart';
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
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: primaryColor));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyUser(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyWallet(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(headline6: TextStyle(color: Colors.black, fontSize: 20)),
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.white,
            elevation: 8.0,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
