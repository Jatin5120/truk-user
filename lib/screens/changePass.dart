import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmPasswordKey = GlobalKey<FormState>();
  bool visibility = true;
  void toggleVisibility() {
    setState(() {
      visibility = !visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Password'),
        backgroundColor: Color.fromRGBO(255, 113, 1, 100),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Change Your Password',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Form(
                    key: passwordKey,
                    child: TextFormField(
                      controller: newPassword,
                      decoration: InputDecoration(
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
                          border: OutlineInputBorder(),
                          hintText: 'New Password'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(
                    right: 20,
                    left: 20,
                  ),
                  child: Form(
                    key: confirmPasswordKey,
                    child: TextFormField(
                      controller: newPassword,
                      decoration: InputDecoration(
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
                          border: OutlineInputBorder(),
                          hintText: 'Confirm New Password'),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: SizedBox(
                    height: height * 0.3,
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 65,
                    width: width,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: RaisedButton(
                      color: Color.fromRGBO(255, 113, 1, 100),
                      onPressed: () {},
                      child: Text(
                        'Save',
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
    );
  }
}
