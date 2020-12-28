import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/firebase_helper/notification_helper.dart';
import 'package:trukapp/fragments/home_map_fragment.dart';
import 'package:trukapp/fragments/my_shipment_fragment.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/models/wallet_model.dart';
import 'package:trukapp/screens/notification.dart';
import 'package:flutter/material.dart';

import 'package:trukapp/utils/drawer_part.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  int currentIndex;
  final PageController _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    Provider.of<MyUser>(context, listen: false).getUserFromDatabase();
    Provider.of<MyWallet>(context, listen: false).getWalletBalance();
    NotificationHelper().registerNotification();
  }

  void onTabTap(int value) {
    setState(() {
      currentIndex = value;
    });
    _pageController.jumpToPage(currentIndex);
  }

  List<Widget> children = [HomeMapFragment(), MyShipment()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Theme(
        data: ThemeData(disabledColor: Colors.black),
        child: Drawer(
          child: DrawerMenu(),
        ),
      ),
      appBar: currentIndex == 1
          ? AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              elevation: 0,
            )
          : AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Colors.white,
              title: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 100,
                  width: 100,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => NotificationScreen(),
                      ),
                    );
                  },
                )
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTabTap,
        selectedItemColor: primaryColor,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        elevation: 12,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SvgPicture.asset(
                'assets/svg/truck_svg.svg',
                height: 15,
                width: 20,
                color: currentIndex == 1 ? primaryColor : Colors.grey,
              ),
            ),
            label: 'My Shipments',
          )
        ],
      ),
      body: PageView.builder(
        onPageChanged: (ind) {
          setState(() {
            currentIndex = ind;
          });
        },
        itemCount: children.length,
        itemBuilder: (context, index) {
          return children[index];
        },
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
