import 'package:trukapp/screens/changePass.dart';
import 'package:trukapp/screens/edit.dart';
import 'package:trukapp/screens/quotes.dart';
import 'package:trukapp/screens/request.dart';
import 'package:trukapp/screens/settings.dart';
import 'package:trukapp/screens/wallets.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;

  Widget myListTile({String title, void Function() onTap, Widget leading}) {
    return ListTile(
      leading: leading,
      title: Text(title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color.fromRGBO(255, 113, 1, 100),
        selectedFontSize: 18,
        elevation: 12,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping), title: Text('My Shipments'))
        ],
      ),
      drawer: Theme(
        data: ThemeData(disabledColor: Colors.black),
        child: Drawer(
          child: ListView(
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
                        'Mukesh Kumar',
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
                        '+91 9987654321',
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                        },
                        child: Text('Edit',
                            style: TextStyle(color: Colors.blue, fontSize: 18)),
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
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Quotes(),
                    ));
                  }),
              myListTile(
                  title: 'Payments',
                  leading: Icon(Icons.payment),
                  onTap: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Wallets(),
                    ));
                  }),
              myListTile(
                  title: 'TruckMoney', leading: Icon(Icons.attach_money)),
              myListTile(
                  title: 'Support',
                  leading: Icon(Icons.account_balance_wallet)),
              myListTile(
                  title: 'Promotions', leading: Icon(Icons.card_giftcard)),
              myListTile(
                  title: 'Settings',
                  leading: Icon(Icons.settings),
                  onTap: () {
                    // Navigator.of(context).pop(true);
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromRGBO(255, 113, 1, 100)),
                      )
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Request(),
                    ));
                  },
                ),
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Container(
          alignment: Alignment.center,
          child: Image(
            height: 100,
            width: 100,
            image: AssetImage('assets/images/logo.png'),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.black,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            Image(
              fit: BoxFit.cover,
              height: height,
              width: width,
              image: AssetImage('assets/images/Rectangle 23.png'),
            ),
            Positioned(
                top: 60,
                child: Container(
                  width: width,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Card(
                    elevation: 12.0,
                    child: TextFormField(
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.place),
                          labelText: 'Enter Pick Up Location'),
                    ),
                  ),
                )),
            Positioned(
              width: width,
              top: 150,
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Card(
                  elevation: 12,
                  child: TextFormField(
                    decoration: InputDecoration(
                        suffixIcon: Icon(Icons.place),
                        labelText: 'Enter Drop Location'),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 65,
                width: width,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: RaisedButton(
                  visualDensity: VisualDensity.comfortable,
                  color: Color.fromRGBO(255, 113, 1, 100),
                  onPressed: () {},
                  child: Text(
                    'Continue Booking',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}