import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../screens/edit.dart';
import '../screens/payments.dart';
import '../screens/promotions.dart';
import '../screens/quotes_screen.dart';
import '../screens/request.dart';
import '../screens/settings.dart';
import '../screens/support_ticket_screen.dart';
import '../screens/trukmoney.dart';

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
              Container(
                padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
                height: 80,
                width: width,
                alignment: Alignment.centerLeft,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: primaryColor,
                  child: Text(
                      pUser.isUserLoading ? '...' : '${pUser.user.name[0]}',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  pUser.isUserLoading ? 'Loading...' : '${pUser.user.name}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    Navigator.of(context).push(CupertinoPageRoute(
                        builder: (context) => EditProfile()));
                  },
                  child: Text('Edit',
                      style: TextStyle(color: Colors.blue, fontSize: 18)),
                ),
              ),
              SizedBox(height: 5),
              Divider(height: 2),
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
        myListTile(
          title: 'Support',
          leading: Icon(Icons.account_balance_wallet),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => SupportTicketScreen(),
              ),
            );
          },
        ),
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
                Icon(Icons.exit_to_app,
                    color: Color.fromRGBO(255, 113, 1, 100)),
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
      title: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      onTap: onTap,
    );
  }
}
