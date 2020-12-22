import 'package:trukapp/screens/home.dart';
import 'package:flutter/material.dart';

class MoreAbout extends StatefulWidget {
  @override
  _MoreAboutState createState() => _MoreAboutState();
}

class _MoreAboutState extends State<MoreAbout> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController companyName = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  GlobalKey<FormState> nameKey = GlobalKey<FormState>();
  GlobalKey<FormState> emailKey = GlobalKey<FormState>();
  GlobalKey<FormState> companyKey = GlobalKey<FormState>();
  GlobalKey<FormState> cityKey = GlobalKey<FormState>();
  GlobalKey<FormState> stateKey = GlobalKey<FormState>();
  GlobalKey<FormState> passwordKey = GlobalKey<FormState>();
  GlobalKey<FormState> confirmPasswordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ImageProvider image = AssetImage('assets/images/logo.png');

    return Scaffold(
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
                  alignment: Alignment.center,
                  height: 40,
                  child: Image(
                    image: image,
                  ),
                ),
                SizedBox(
                  height: height * 0.1,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Tell us more about you:',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    key: nameKey,
                    child: TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          // prefixIcon: Container(
                          //   padding: EdgeInsets.only(left: 10),
                          //   alignment: Alignment.centerLeft,
                          //   width: 80,
                          //   child: Image(
                          //     height: 20,
                          //     image: AssetImage('assets/images/india.png'),
                          //   ),
                          // ),
                          hintText: 'Name *',
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
                    key: emailKey,
                    child: TextFormField(
                      controller: email,
                      decoration: InputDecoration(
                          hintText: 'Email ID *', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    key: companyKey,
                    child: TextFormField(
                      controller: companyName,
                      decoration: InputDecoration(
                          hintText: 'Company Name *',
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
                    key: cityKey,
                    child: TextFormField(
                      controller: city,
                      decoration: InputDecoration(
                          hintText: 'City *', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    key: stateKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'State *', border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 15),
                  child: Form(
                    key: passwordKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Enter Password *',
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
                    key: confirmPasswordKey,
                    child: TextFormField(
                      decoration: InputDecoration(
                          hintText: 'Confirm Password *',
                          border: OutlineInputBorder()),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
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
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
                      },
                      child: Text(
                        'Continue',
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
