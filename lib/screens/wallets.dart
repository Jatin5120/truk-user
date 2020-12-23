import 'package:flutter/material.dart';

import '../widgets/widgets.dart';

class Wallets extends StatefulWidget {
  @override
  _WalletsState createState() => _WalletsState();
}

class _WalletsState extends State<Wallets> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  Widget myWallet({String name, String icon, void Function() onTap}) {
    return Container(
      alignment: Alignment.center,
      height: 80,
      padding: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 8,
        child: ListTile(
          contentPadding:
              EdgeInsets.only(left: 10, right: 10, bottom: 8, top: 8),
          leading: Image(
            fit: BoxFit.fitWidth,
            width: 50,
            height: 50,
            image: AssetImage('assets/images/$icon'),
          ),
          title: Text(
            name,
            style: TextStyle(fontSize: 18),
          ),
          trailing: InkWell(
            onTap: onTap,
            child: Text(
              'Link',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> wallets = [
    {},
    {'name': 'Paytm', 'icon': 'paytm_logo.png', 'onTap': () {}},
    {'name': 'Phonepe', 'icon': 'phone-pe.png', 'onTap': () {}},
    {'name': 'Amazon Pay', 'icon': 'amazon_logo.png', 'onTap': () {}},
    {'name': 'Google Pay', 'icon': 'gpay_logo.png', 'onTap': () {}},
    {'name': 'TrukMoney', 'icon': 'wallet_logo.png', 'onTap': () {}}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallets'),
      ),
      body: Container(
          padding: EdgeInsets.only(top: 30),
          child: ListView(
            shrinkWrap: true,
            children: [
              myWallet(
                  icon: 'paytm_logo.png',
                  name: 'Paytm',
                  onTap: () {
                    print('hi');
                    paymentSuccessful(context: context, shipmentId: '12345678');
                  }),
              myWallet(
                  icon: 'phone-pe.png',
                  name: 'Phonepe',
                  onTap: () {
                    print('hello');
                  }),
              myWallet(
                  icon: 'amazon_logo.png', name: 'Amazon Pay', onTap: () {}),
              myWallet(icon: 'gpay_logo.png', name: 'Google Pay', onTap: () {}),
              myWallet(
                  icon: 'wallet_logo.png', name: 'TrukMoney', onTap: () {}),
            ],
          )),
    );
  }
}
