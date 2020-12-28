import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/screens/edit.dart';
import 'package:trukapp/screens/payments.dart';
import 'package:trukapp/screens/promotions.dart';
import 'package:trukapp/screens/quotes_screen.dart';
import 'package:trukapp/screens/request.dart';
import 'package:trukapp/screens/settings.dart';
import 'package:trukapp/screens/trukmoney.dart';

import 'constants.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final pUser = Provider.of<MyUser>(context);
    return ListView(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  pUser.isUserLoading ? 'Loading...' : '${pUser.user.name}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  pUser.isUserLoading ? 'Loading...' : '${pUser.user.mobile}',
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => EditProfile()));
                  },
                  child: Text('Edit', style: TextStyle(color: Colors.blue, fontSize: 18)),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
        myListTile(
            title: 'Quotes',
            leading: Icon(Icons.format_quote),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => QuotesScreen(),
              ));
            }),
        myListTile(
          title: 'Payments',
          leading: Icon(Icons.payment),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => Payment(),
              ),
            );
          },
        ),
        myListTile(
          title: 'TruckMoney',
          leading: Icon(Icons.attach_money),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => TrukMoney(),
              ),
            );
          },
        ),
        myListTile(title: 'Support', leading: Icon(Icons.account_balance_wallet)),
        myListTile(
            title: 'Promotions',
            leading: Icon(Icons.card_giftcard),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => Promotion(),
              ));
            }),
        myListTile(
            title: 'Settings',
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) {
                  return Settings();
                },
              ));
            }),
        SizedBox(height: 50),
        Container(
          height: 50,
          width: width,
          alignment: Alignment.center,
          child: GestureDetector(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.exit_to_app, color: Color.fromRGBO(255, 113, 1, 100)),
                SizedBox(width: 10),
                Text(
                  'Logout',
                  style: TextStyle(fontSize: 20, color: primaryColor),
                )
              ],
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => Request(),
              ));
            },
          ),
        )
      ],
    );
  }

  Widget myListTile({String title, void Function() onTap, Widget leading}) {
    return ListTile(
      leading: leading,
      title: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      onTap: onTap,
    );
  }
}
