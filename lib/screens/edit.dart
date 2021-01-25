import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import '../firebase_helper/firebase_helper.dart';
import '../models/user_model.dart';
import '../helper/email_validator.dart';
import '../utils/constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    final pUser = Provider.of<MyUser>(context, listen: false);
    UserModel model = pUser.userModel;
    nameController.text = model.name;
    companyNameController.text = model.company;
    mobileNumberController.text = model.mobile;
    emailController.text = model.email;
  }

  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context).locale;
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.editProfile)),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                      }
                      return null;
                    },
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.name),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    readOnly: true,
                    controller: mobileNumberController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.mobile),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    controller: emailController,
                    validator: (input) => input.isValidEmail()
                        ? null
                        : AppLocalizations.getLocalizationValue(locale, LocaleKey.invalidEmail),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.email),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: TextFormField(
                    validator: (value) {
                      if (value.isEmpty) {
                        return AppLocalizations.getLocalizationValue(locale, LocaleKey.requiredText);
                      }
                      return null;
                    },
                    controller: companyNameController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.getLocalizationValue(locale, LocaleKey.company),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
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
                        String company = companyNameController.text.trim();
                        String name = nameController.text.trim();
                        String email = emailController.text.trim();
                        await FirebaseHelper().updateUser(
                          company: company,
                          email: email,
                          name: name,
                        );
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                            msg: AppLocalizations.getLocalizationValue(locale, LocaleKey.profileUpdated));
                      }
                    },
                    child: Text(
                      AppLocalizations.getLocalizationValue(locale, LocaleKey.update),
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
