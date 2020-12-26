import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

class TrukMoney extends StatefulWidget {
  @override
  _TrukMoneyState createState() => _TrukMoneyState();
}

class _TrukMoneyState extends State<TrukMoney>
    with SingleTickerProviderStateMixin {
  static int initialIndex = 0;
  TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: initialIndex,
      length: 3,
      vsync: this,
    );
    super.initState();
  }

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
            padding: padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
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
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(5)),
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
                  width: size.width * 0.7,
                  // padding: padding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          child: GestureDetector(
                            onTap: () {},
                            child: Text('₹ 500'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          child: GestureDetector(
                            onTap: () {},
                            child: Text('₹ 1,000'),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(top: 10, bottom: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          child: GestureDetector(
                            onTap: () {},
                            child: Text('₹ 2,000'),
                          ),
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
                TabBar(
                  controller: tabController,
                  indicatorColor: primaryColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  isScrollable: true,
                  labelColor: primaryColor,
                  unselectedLabelColor: Colors.black,
                  tabs: [
                    Text(
                      'BHIM UPI',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      'DEBIT CARD',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      'CREDIT CARD',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    )
                  ],
                ),
                Container(
                  height: 60,
                  child: TabBarView(
                    controller: tabController,
                    children: [
                      Text('hi'),
                      Text('hi'),
                      Text('hi'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 55,
                  width: size.width,
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
