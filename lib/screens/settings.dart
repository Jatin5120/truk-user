import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/screens/change_language_screen.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  bool notificationOn = true;

  @override
  Widget build(BuildContext context) {
    final pUser = Provider.of<MyUser>(context);
    notificationOn = pUser.user.notification;
    final locale = AppLocalizations.of(context).locale;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.getLocalizationValue(locale, LocaleKey.settings),
        ),
      ),
      body: Container(
        height: height,
        child: Column(
          children: [
            Container(
              width: width,
              child: Row(
                children: [
                  SizedBox(
                    width: 16,
                  ),
                  Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: SwitchListTile(
                      activeColor: Color.fromRGBO(255, 113, 1, 100),
                      title: Text(
                        AppLocalizations.getLocalizationValue(locale, LocaleKey.notification),
                      ),
                      value: notificationOn,
                      onChanged: (bool value) async {
                        setState(() {
                          notificationOn = value;
                        });
                        await pUser.updateNotification(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => ChangeLanguageScreen(),
                  ),
                );
              },
              leading: Icon(
                Icons.g_translate,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.getLocalizationValue(locale, LocaleKey.language),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.info,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.getLocalizationValue(locale, LocaleKey.about),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                Icons.library_books,
                color: Colors.black,
              ),
              title: Text(
                AppLocalizations.getLocalizationValue(locale, LocaleKey.terms),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
              ),
            ),
            Spacer(),
            ListTile(
              onTap: () async {
                String url = "https://www.agumentik.com/";
                bool canL = await canLaunch(url);
                if (canL) {
                  launch(url);
                }
              },
              title: Center(
                child: Text(
                  'Developed by Agumentik\nSoftware Pvt. Ltd.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
