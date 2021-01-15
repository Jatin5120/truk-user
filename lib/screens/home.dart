import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:trukapp/models/chat_controller.dart';
import 'package:trukapp/models/shipment_model.dart';
import '../firebase_helper/notification_helper.dart';
import '../fragments/home_map_fragment.dart';
import '../fragments/my_shipment_fragment.dart';
import '../models/user_model.dart';
import '../models/wallet_model.dart';
import '../screens/notification.dart';
import 'package:flutter/material.dart';

import '../utils/drawer_part.dart';

import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
  int currentIndex, backTaps = 0;
  bool back = false;
  static final PageController _pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    Provider.of<MyUser>(context, listen: false).getUserFromDatabase();
    Provider.of<MyWallet>(context, listen: false).getWalletBalance();
    Provider.of<MyShipments>(context, listen: false).getAllShipments();
    Provider.of<ChatController>(context, listen: false).getAllMessages();
    NotificationHelper().configLocalNotification();
    NotificationHelper().registerNotification();
  }

  Future<bool> _onBackPress() async {
    if (currentIndex != 0) {
      setState(() {
        currentIndex = 0;
      });
      _pageController.jumpToPage(currentIndex);
      return false;
    }
    Fluttertoast.showToast(msg: "Press back again to exit");
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        backTaps = 0;
      });
    });
    if (backTaps == 0) {
      setState(() {
        backTaps = 1;
      });
      _onBackPress();
    } else {
      return true;
    }
    return false;
  }

  void onTabTap(int value) {
    setState(() {
      currentIndex = value;
    });
    _pageController.jumpToPage(currentIndex);
  }

  final List<Widget> children = [
    HomeMapFragment(),
    MyShipment(
      onAppbarBack: () {
        _pageController.jumpToPage(0);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPress,
      child: Scaffold(
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
          selectedFontSize: 17,
          unselectedFontSize: 14,
          elevation: 12,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.dashboard,
                  color: currentIndex == 0 ? primaryColor : Colors.grey,
                  size: 22,
                ),
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: SvgPicture.asset(
                  'assets/svg/truck_svg.svg',
                  height: 17,
                  width: 22,
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
      ),
    );
  }
}
