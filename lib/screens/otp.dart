import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/screens/tellUsMore.dart';
import 'package:trukapp/utils/constants.dart';

import 'home.dart';

class OTP extends StatefulWidget {
  final String number;
  OTP({this.number});
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController otp = TextEditingController();
  GlobalKey<FormState> otpKey = GlobalKey<FormState>();
  String phoneNumber = '';
  int secondsRemaining = 15;

  @override
  void initState() {
    super.initState();
    getRemainingTime();
    phoneNumber = '+91 ${widget.number}';
    //if (mounted) setState(() {});
  }

  getRemainingTime() {
    Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (secondsRemaining == 0) {
          timer.cancel();
        } else {
          secondsRemaining--;
        }
        if (mounted) {
          setState(() {});
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                height: 60,
                child: Image(
                  image: AssetImage('assets/images/logo.png'),
                ),
              ),
              SizedBox(
                height: height * 0.15,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Enter the OTP sent to you at',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      phoneNumber,
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Edit',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 15),
                child: Form(
                  key: otpKey,
                  child: TextFormField(
                    maxLength: 6,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please enter the OTP',
                      counter: Container(),
                      counterText: "",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "00:${secondsRemaining < 10 ? '0${secondsRemaining.toString()}' : '${secondsRemaining.toString()}'}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    secondsRemaining == 0
                        ? Container(
                            child: InkWell(
                              onTap: () {},
                              child: Text(
                                'Resend OTP',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.blue),
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 65,
                width: width,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: RaisedButton(
                  color: primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => MoreAbout(),
                      ),
                    );

                    Navigator.of(context).pushReplacement(CupertinoPageRoute(
                      builder: (context) => HomeScreen(),
                    ));
                  },
                  child: Text(
                    'Verify Now',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
