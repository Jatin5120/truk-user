import 'package:trukapp/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

class MoreAbout extends StatefulWidget {
  @override
  _MoreAboutState createState() => _MoreAboutState();
}

class _MoreAboutState extends State<MoreAbout> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          height: 65,
          width: width,
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: RaisedButton(
            color: primaryColor,
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
      ),
      body: Form(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 50,
                    ),
                  ),
                  SizedBox(
                    height: 40,
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
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email ID*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      hintText: 'Company Name*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'City*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _stateController,
                    decoration: InputDecoration(
                      hintText: 'State*',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 15,
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
