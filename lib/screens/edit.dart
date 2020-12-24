import 'package:flutter/material.dart';

import '../utils/constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController name = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: TextFormField(
                      controller: companyName,
                      decoration: InputDecoration(
                          labelText: 'Name', border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: TextFormField(
                      controller: mobileNumber,
                      decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          labelText: 'Email ID', border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20, right: 15),
                    child: TextFormField(
                      controller: companyName,
                      decoration: InputDecoration(
                          labelText: 'Company Name',
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.4,
                  ),
                  Container(
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    height: 65,
                    width: width,
                    padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                    child: RaisedButton(
                      color: primaryColor,
                      onPressed: () {},
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
