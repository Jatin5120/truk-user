import 'package:flutter/material.dart';
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
  void onChanged(bool value) {
    setState(() {
      notificationOn = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
                    color: Colors.grey,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: SwitchListTile(
                      activeColor: Color.fromRGBO(255, 113, 1, 100),
                      title: Text('Notification'),
                      value: notificationOn,
                      onChanged: onChanged,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Truk App'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {},
              ),
            ),
            ListTile(
              leading: Icon(Icons.library_books),
              title: Text('Terms and conditions'),
              trailing: IconButton(
                icon: Icon(Icons.arrow_right),
                onPressed: () {},
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
