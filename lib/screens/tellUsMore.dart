import 'package:firebase_auth/firebase_auth.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../firebase_helper/firebase_helper.dart';
import '../screens/home.dart';
import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../helper/email_validator.dart';

class MoreAbout extends StatefulWidget {
  @override
  _MoreAboutState createState() => _MoreAboutState();
}

class _MoreAboutState extends State<MoreAbout> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _companyNameController.dispose();
    _cityController.dispose();
    _stateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: 65,
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: RaisedButton(
            color: primaryColor,
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                setState(() {
                  isLoading = true;
                });
                if (user != null) {
                  String uid = user.uid;
                  String mobile = user.phoneNumber;
                  String email = _emailController.text.trim();
                  String name = _nameController.text.trim();
                  String city = _cityController.text.trim();
                  String state = _stateController.text.trim();
                  String company =
                      _companyNameController.text.trim().isEmpty ? 'Individual' : _companyNameController.text.trim();
                  await FirebaseHelper().insertUser(uid, name, email, mobile, company, city, state);
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                      (b) => false);
                } else {}
              }
            },
            child: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    AppLocalizations.getLocalizationValue(locale, LocaleKey.continueText),
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    AppLocalizations.getLocalizationValue(locale, LocaleKey.registerTitle),
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.name),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: (input) => input.isValidEmail()
                        ? null
                        : AppLocalizations.getLocalizationValue(locale, LocaleKey.invalidEmail),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _companyNameController,
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.company),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _cityController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.city),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                      }
                      return null;
                    },
                    controller: _stateController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.state),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
