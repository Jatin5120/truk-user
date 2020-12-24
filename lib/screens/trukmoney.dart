import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

class TrukMoney extends StatefulWidget {
  @override
  _TrukMoneyState createState() => _TrukMoneyState();
}

class _TrukMoneyState extends State<TrukMoney> {
  @override
  Widget build(BuildContext context) {
    final EdgeInsetsGeometry padding = EdgeInsets.only(left: 20, right: 20);
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('TrukMoney'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    children: [
                      Text('TrukMoney Balance'),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '₹ 2,500',
                        style: TextStyle(color: Colors.orange, fontSize: 24),
                      )
                    ],
                  ),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(5)),
                ),
                // SizedBox(height: 10,),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Topup Wallet',
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter Amount',
                      prefixText: '₹'),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Recommended',
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
                Container(
                  padding: padding,
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text('₹ 500'),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text('₹ 1,000'),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {},
                          child: Text('₹ 2,000'),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text('Debit From',
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 65,
                  width: size.width,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: RaisedButton(
                    color: primaryColor,
                    onPressed: () {},
                    child: Text(
                      'Topup Wallet',
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
