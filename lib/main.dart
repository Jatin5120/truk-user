import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/models/chat_controller.dart';
import 'package:trukapp/models/localization_controller.dart';
import 'package:trukapp/models/quote_model.dart';
import 'package:trukapp/models/wallet_model.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';
import 'locale/language_bloc/language_bloc.dart';
import 'models/shipment_model.dart';
import 'models/user_model.dart';
import 'screens/splash.dart';
import 'package:flutter/material.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    Phoenix(child: MyApp()),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale locale;
  @override
  void initState() {
    super.initState();
    SharedPref().getLocale().then((value) {
      locale = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: primaryColor));
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MyUser(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyWallet(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyShipments(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatController(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocalizationController(),
        ),
        ChangeNotifierProvider(
          create: (context) => MyQuotes(),
        ),
      ],
      child: BlocProvider(
        create: (_) => LanguageBloc()..add(LanguageLoadStarted()),
        child: BlocBuilder<LanguageBloc, Language>(
          buildWhen: (prevState, currentState) => prevState != currentState,
          builder: (context, snapshot) {
            return MaterialApp(
              localizationsDelegates: [
                const AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('en', 'US'),
                const Locale('hi', 'IN'),
                const Locale('te', 'IN'),
              ],
              locale: snapshot.locale,
              theme: ThemeData(
                appBarTheme: AppBarTheme(
                  textTheme: TextTheme(
                      headline6: TextStyle(color: Colors.black, fontSize: 20)),
                  iconTheme: IconThemeData(color: Colors.black),
                  color: Colors.white,
                  elevation: 0,
                ),
              ),
              debugShowCheckedModeBanner: false,
              home: Splash(),
            );
          },
        ),
      ),
    );
  }
}
