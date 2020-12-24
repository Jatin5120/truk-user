import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/models/user_model.dart';
import 'package:trukapp/screens/home.dart';
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
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String phoneNumber = '';
  int secondsRemaining = 15;

  bool isFilled = false, isLoading = true, isCodeNotSent = true;
  String smsCode;
  String _message;
  FirebaseAuth _auth;
  String _verificationId;

  void _verifyPhoneNumber() async {
    setState(() {
      _message = '';
      isLoading = true;
    });
    final PhoneVerificationCompleted verificationCompleted = (AuthCredential phoneAuthCredential) {
      _signInWithPhoneNumber(credential: phoneAuthCredential);
    };

    final PhoneVerificationFailed verificationFailed = (authException) {
      setState(() {
        isLoading = false;
        _message =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
      Fluttertoast.showToast(msg: _message);
    };

    final PhoneCodeSent codeSent = (String verificationId, [int forceResendingToken]) async {
      Fluttertoast.showToast(msg: "OTP sent");
      getRemainingTime();
      setState(() {
        isLoading = false;
        isCodeNotSent = false;
      });
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout = (String verificationId) {
      _verificationId = verificationId;
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: "+91" + widget.number,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber({AuthCredential credential}) async {
    setState(() {
      isLoading = true;
    });
    AuthCredential authCredential;
    if (credential != null) {
      authCredential = credential;
    } else {
      smsCode = _otpController.text.trim();
      authCredential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: this.smsCode,
      );
    }

    Fluttertoast.showToast(msg: "Verification in progress...");

    UserCredential _results = await _auth.signInWithCredential(authCredential).catchError((onError) {
      Fluttertoast.showToast(msg: "Invalid OTP");
      setState(() {
        isLoading = false;
      });
      return;
    });
    try {
      User user = _results.user;

      setState(() {
        if (user != null) {
          _message = 'Successfully signed in';
        } else {
          _message = 'Sign in failed';
        }
      });
      Fluttertoast.showToast(msg: _message);
      if (user != null) matchOtp(user);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    phoneNumber = '+91 ${widget.number}';
    _auth = FirebaseAuth.instance;
    _verifyPhoneNumber();
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
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SafeArea(
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
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 6,
                    controller: _otpController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return '*Required';
                      }
                      if (value.trim().length < 6) {
                        return '*Invalid OTP';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Please enter the OTP',
                      counterText: "",
                      border: OutlineInputBorder(),
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
                                onTap: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(),
                                  ));
                                },
                                child: Text(
                                  'Resend OTP',
                                  style: TextStyle(fontSize: 18, color: Colors.blue),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  height: 65,
                  width: width,
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: RaisedButton(
                    color: primaryColor,
                    onPressed: isLoading
                        ? () {}
                        : () {
                            if (_formKey.currentState.validate()) {
                              _signInWithPhoneNumber();
                            }
                          },
                    child: isLoading
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : Text(
                            'Verify Now',
                            style: TextStyle(fontSize: 16, color: Colors.white),
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

  void matchOtp(User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Successfully"),
          content: Text("Otp matched successfully."),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((_) async {
                  UserModel userModel = await FirebaseHelper().getCurrentUser(uid: user.uid);
                  if (userModel == null) {
                    //new user
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => MoreAbout()),
                    );
                  } else {
                    //existing user
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (_) => HomeScreen()), (b) => false);
                  }
                });
              },
            )
          ],
        );
      },
    );
  }
}
