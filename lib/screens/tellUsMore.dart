import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/screens/tcPage.dart';
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

  bool isTC = false;
  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return primaryColor;
    }
    return primaryColor;
  }

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String radioValue = "Individual";

  @override
  void initState() {
    super.initState();
    user = _auth.currentUser;
    _companyNameController.text = radioValue;
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
    print(_auth.currentUser.displayName);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: 65,
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: primaryColor,
            ),
            onPressed: isTC
                ? () async {
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        isLoading = true;
                      });
                      if (user != null && isTC) {
                        String uid = user.uid;
                        String mobile = user.phoneNumber;
                        String email = _emailController.text.trim();
                        String name = _nameController.text.trim();
                        String city = _cityController.text.trim();
                        String state = _stateController.text.trim();
                        String gst = _gstController.text.isEmpty
                            ? "NA"
                            : _gstController.text;
                        String company =
                            _companyNameController.text.trim().isEmpty
                                ? 'Individual'
                                : _companyNameController.text.trim();
                        await FirebaseHelper().insertUser(
                            uid, name, email, mobile, company, city, state,
                            gst: gst);
                        setState(() {
                          isLoading = false;
                        });
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                            (b) => false);
                      } else {
                        if (user == null) {
                          Fluttertoast.showToast(
                              msg: 'Please fill all the fields');
                        } else if (!isTC) {
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(
                              msg: 'Please Accept terms and conditions');
                        }
                      }
                    }
                  }
                : null,
            child: isLoading
                ? CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    AppLocalizations.getLocalizationValue(
                        locale, LocaleKey.continueText),
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
            child: Column(
              children: [
                Container(
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
                        AppLocalizations.getLocalizationValue(
                            locale, LocaleKey.registerTitle),
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: 50,
                        width: width,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text("Individual"),
                                value: "Individual",
                                groupValue: radioValue,
                                onChanged: (b) {
                                  setState(() {
                                    _companyNameController.text = "Individual";
                                    radioValue = b;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                contentPadding: const EdgeInsets.all(0),
                                title: Text("Company"),
                                value: "Company",
                                groupValue: radioValue,
                                onChanged: (b) {
                                  _companyNameController.text = "";
                                  setState(() {
                                    radioValue = b;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.requiredText);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.name),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _emailController,
                        validator: (input) => input.trim().isValidEmail()
                            ? null
                            : AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.invalidEmail),
                        decoration: InputDecoration(
                          labelText: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.email),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _companyNameController,
                        readOnly: radioValue == "Individual",
                        enabled: radioValue != "Individual",
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.requiredText);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.company),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (radioValue == "Company") ...[
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          controller: _gstController,
                          validator: (value) {
                            if (value.isEmpty) {
                              return AppLocalizations.getLocalizationValue(
                                  locale, LocaleKey.requiredText);
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.gst),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: _cityController,
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.requiredText);
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.city),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value.isEmpty) {
                            return AppLocalizations.getLocalizationValue(
                                locale, LocaleKey.requiredText);
                          }
                          return null;
                        },
                        controller: _stateController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.getLocalizationValue(
                              locale, LocaleKey.state),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Row(
                    children: [
                      Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isTC,
                          onChanged: (bool value) {
                            setState(() {
                              isTC = value;
                            });
                          }),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              // TextSpan(
                              //   text: AppLocalizations.getLocalizationValue(
                              //       locale, LocaleKey.accept),
                              //   style: TextStyle(color: Colors.black),
                              // ),
                              TextSpan(
                                text:
                                    "${AppLocalizations.getLocalizationValue(locale, LocaleKey.insuranceText2)}",
                                style: TextStyle(
                                    color: primaryColor,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    var insurance = await FirebaseHelper()
                                        .getCompanyInsurance();
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => TCPage(
                                          data: insurance,
                                        ),
                                      ),
                                    );
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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
    );
  }
}
