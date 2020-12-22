import 'package:flutter/cupertino.dart';
import 'package:trukapp/screens/otp.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

class Signup extends StatefulWidget {
  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<Signup> {
  TextEditingController mobileNumber = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ImageProvider image = AssetImage('assets/images/india.png');
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          height: size.height,
          width: size.width,
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
                height: size.height * 0.15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  'Enter your mobile number',
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 15),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: false,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      prefixIcon: Image(
                        height: 18,
                        image: image,
                      ),
                      counter: Container(),
                      counterText: "",
                      labelText: 'Mobile Number',
                      hintText: 'e.g., 1234567890',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 65,
                width: size.width,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: RaisedButton(
                  color: primaryColor,
                  onPressed: () {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => OTP(),
                      ),
                    );
                  },
                  child: Text(
                    'Generate OTP',
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
