import 'package:trukapp/screens/login.dart';
import 'package:trukapp/screens/signup.dart';
import 'package:trukapp/screens/tellUsMore.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:trukapp/utils/walkthrough_widget.dart';

class CarouselScreen extends StatefulWidget {
  @override
  CarouselScreenState createState() => CarouselScreenState();
}

class CarouselScreenState extends State<CarouselScreen> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: height,
        child: Column(
          children: [
            Container(
              height: height * 0.8,
              child: Carousel(
                dotBgColor: Colors.transparent,
                indicatorBgPadding: 8,
                dotSize: 6,
                autoplay: false,
                animationCurve: Curves.easeInSine,
                dotIncreasedColor: primaryColor,
                dotColor: Colors.grey,
                images: walkthroughList.map((e) {
                  return WalkthroughWidget(
                    image: e['image'],
                    textHead: e['title'],
                    textSubHead: e['subtitle'],
                  );
                }).toList(),
              ),
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: width,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: RaisedButton(
                color: primaryColor,
                onPressed: () async {
                  await SharedPref().setOld();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Signup(),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text(
                    'Get Started',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
