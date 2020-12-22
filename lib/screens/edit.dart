import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Color.fromRGBO(255, 113, 1, 100)),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    child: TextFormField(
                      controller: companyName,
                      decoration: InputDecoration(
                          hintText: 'Name', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    child: TextFormField(
                      controller: mobileNumber,
                      decoration: InputDecoration(
                          hintText: 'Mobile Number',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: 'Email ID', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    child: TextFormField(
                      controller: companyName,
                      decoration: InputDecoration(
                          hintText: 'Company Name',
                          border: OutlineInputBorder()),
                    ),
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
                    color: Color.fromRGBO(255, 113, 1, 100),
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
    );
  }
}
