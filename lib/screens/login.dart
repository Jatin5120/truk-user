import 'package:trukapp/screens/carousel.dart';
import 'package:trukapp/screens/signup.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  bool visibility = true;

  void toggleVisibility() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider image = AssetImage('assets/images/logo.png');
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              height: height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: Image(
                      image: image,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      'Welcome back! Sign in with your mobile number',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Container(
                          padding: EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          width: 80,
                          child: Image(
                            height: 20,
                            image: AssetImage('assets/images/india.png'),
                          ),
                        ),
                        labelText: 'Enter Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: TextFormField(
                      obscureText: visibility,
                      decoration: InputDecoration(
                          prefixIcon: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.centerLeft,
                              width: 80,
                              child: Icon(
                                Icons.lock_outline,
                                size: 30,
                              )),
                          labelText: 'Enter Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              toggleVisibility();
                            },
                            icon: visibility
                                ? Icon(
                                    Icons.visibility,
                                    color: Colors.blue,
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    color: Colors.blue,
                                  ),
                          ),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          'Forgot your password?',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          onTap: () {},
                          child: Text(
                            'Reset here',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: SizedBox(
                      height: height * 0.3,
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Signup(),
                              ));
                            },
                            child: Text(
                              'Sign up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.blue,
                              ),
                            ))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      height: 65,
                      width: width,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: RaisedButton(
                        color: primaryColor,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => CarouselScreen(),
                          ));
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
