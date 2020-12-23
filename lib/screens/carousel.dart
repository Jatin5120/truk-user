import 'package:trukapp/screens/login.dart';
import 'package:trukapp/screens/signup.dart';
import 'package:trukapp/screens/tellUsMore.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:trukapp/sessionmanagement/session_manager.dart';
import 'package:trukapp/utils/constants.dart';
import 'package:trukapp/utils/walkthrough_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/constants.dart';

class CarouselScreen extends StatefulWidget {
  @override
  CarouselScreenState createState() => CarouselScreenState();
}

class CarouselScreenState extends State<CarouselScreen> {
  int pageIndex = 0;
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: height,
        child: Column(
          children: [
            Container(
              height: height * 0.8,
              child: Carousel(
                onImageChange: (d, index) {
                  setState(() {
                    pageIndex = index;
                  });
                },
                dotBgColor: Colors.transparent,
                indicatorBgPadding: 8,
                dotSize: 6,
                autoplay: false,
                animationCurve: Curves.easeInSine,
                dotIncreasedColor: Colors.white,
                dotColor: Colors.white,
                images: walkthroughList.map((e) {
                  return WalkthroughWidget(
                    image: e['image'],
                    textHead: e['title'],
                    textSubHead: e['subtitle'],
                  );
                }).toList(),
              ),
            ),
            Container(
              height: 30,
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: walkthroughList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: const EdgeInsets.only(right: 5),
                      child: SvgPicture.asset(
                        'assets/svg/truck_svg.svg',
                        height: 20,
                        color: index == pageIndex ? primaryColor : Colors.grey,
                      ),
                    );
                  },
                ),
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
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
