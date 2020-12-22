import 'package:trukapp/screens/login.dart';
import 'package:trukapp/screens/tellUsMore.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';

class CarouselScreen extends StatefulWidget {
  @override
  CarouselScreenState createState() => CarouselScreenState();
}

class CarouselScreenState extends State<CarouselScreen> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    ImageProvider image1 = AssetImage('assets/images/walk_1.png');
    ImageProvider image2 = AssetImage('assets/images/walk_2.png');
    ImageProvider image3 = AssetImage('assets/images/walk_3.png');

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
                dotIncreasedColor: Colors.grey,
                dotColor: Color.fromRGBO(255, 113, 1, 100),
                images: [
                  Container(
                    child: Column(
                      children: [
                        Image(
                          height: height * 0.5,
                          fit: BoxFit.fill,
                          image: image1,
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Live Transport Market',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Book Trucks, Trailers & Tankers from live',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Image(
                          height: height * 0.5,
                          fit: BoxFit.fill,
                          image: image2,
                        ),
                        SizedBox(
                          height: height * 0.04,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'One Tap Online Tracking',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Find your Truck on Finger tip and Track',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Image(
                            height: height * 0.5,
                            fit: BoxFit.fill,
                            image: image3),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Partial Load Services',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            'Get your load reach the destination in time',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Login(),
                      ));
                    },
                    child: Text(
                      'Sign In',
                      style: TextStyle(fontSize: 18, color: Colors.blue),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: height * 0.03,
            ),
            Flexible(
              flex: 1,
              child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                height: 65,
                width: width,
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: RaisedButton(
                  color: Color.fromRGBO(255, 113, 1, 100),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MoreAbout(),
                    ));
                  },
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
