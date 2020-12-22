import 'package:flutter/material.dart';

class Terms extends StatefulWidget {
  @override
  _TermsState createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Terms and Conditions'),
        backgroundColor: Color.fromRGBO(255, 113, 1, 100),
        elevation: 0.0,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text(
                  'Truk App',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Text('Please read these Terms of Use Carefully',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
