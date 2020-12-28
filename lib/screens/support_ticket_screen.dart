import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/support.dart';
import '../utils/no_data_page.dart';

class SupportTicketScreen extends StatefulWidget {
  @override
  _SupportTicketScreenState createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Support Tickets'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Support(),
            ),
          );
        },
        child: NoDataPage(
          text: 'No Tickets',
        ),
      ),
    );
  }
}
