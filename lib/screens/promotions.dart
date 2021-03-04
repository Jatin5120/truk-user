import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info/package_info.dart';
import 'package:share/share.dart';
import 'package:trukapp/firebase_helper/firebase_helper.dart';
import 'package:trukapp/locale/app_localization.dart';
import 'package:trukapp/locale/locale_keys.dart';
import 'package:trukapp/models/coupon_model.dart';
import 'package:trukapp/utils/constants.dart';

import '../utils/constants.dart';

class Promotion extends StatefulWidget {
  @override
  _PromotionState createState() => _PromotionState();
}

class _PromotionState extends State<Promotion> {
  double get height => MediaQuery.of(context).size.height;
  double get width => MediaQuery.of(context).size.width;
  Locale locale;
  final PageController pageController = PageController(initialPage: 0, viewportFraction: 0.90);
  String packageName = "";
  int currentCoupon = 0;
  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      packageName = packageInfo.packageName;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    locale = AppLocalizations.of(context).locale;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Promotions'),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection(FirebaseHelper.couponCollection).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return Center(
                      child: Text(AppLocalizations.getLocalizationValue(locale, LocaleKey.noData)),
                    );
                  }
                  if (snapshot.data.size <= 0) {
                    return Container();
                  }
                  return Container(
                    height: 110,
                    child: PageView.builder(
                      itemCount: snapshot.data.size,
                      scrollDirection: Axis.horizontal,
                      controller: pageController,
                      pageSnapping: true,
                      //onPageChanged: (index) => setState(() => currentCoupon = index),
                      itemBuilder: (context, index) {
                        CouponModel cM = CouponModel.fromSnap(snapshot.data.docs[index]);
                        print(cM.code);
                        return buildCoupons(cM);
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Center(
                  child: Text(
                    'Refer Us to your Friends',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      color: const Color(0xff212121),
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Image(
                  image: AssetImage('assets/images/promotion.jpg'),
                ),
              ),
              Center(
                child: Text(
                  'Let them avail the benefits like you',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xff757575),
                    height: 1.5625,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Copy and Share Via Link',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xff212121),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x29000000),
                        offset: Offset(0, 3),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'https://play.google.com/store/apps/details?id=$packageName',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(
                            new ClipboardData(
                              text: 'https://play.google.com/store/apps/details?id=$packageName',
                            ),
                          );
                          Fluttertoast.showToast(
                            msg: 'Copied',
                            backgroundColor: primaryColor,
                            timeInSecForIosWeb: 2,
                          );
                        },
                        child: Icon(
                          Icons.copy,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  'OR Share',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    color: const Color(0xff212121),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      String d = await FlutterShareMe().shareToWhatsApp(
                        msg:
                            'Look this awesome transportation app\n\nCheck out Truk App https://play.google.com/store/apps/details?id=$packageName',
                      );
                      if (d.contains('false')) {
                        Fluttertoast.showToast(msg: 'App isn\'t installed');
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: primaryColor,
                      ),
                      child: Image.asset(
                        'assets/images/whatsapp.png',
                        height: 50,
                        width: 50,
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () async {
                  //     String d = await FlutterShareMe().shareToFacebook(
                  //         msg:
                  //             'Look this awesome transportation app\n\nCheck out Truk App https://play.google.com/store/apps/details?id=$packageName');
                  //     if (d.contains('false')) {
                  //       Fluttertoast.showToast(msg: 'App isn\'t installed');
                  //     }
                  //   },
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(50),
                  //       color: primaryColor,
                  //     ),
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(50),
                  //       child: Image.asset(
                  //         'assets/images/fb_share.png',
                  //         height: 50,
                  //         width: 50,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primaryColor,
                    ),
                    height: 50,
                    width: 50,
                    child: IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.share),
                      onPressed: () {
                        Share.share(
                          'Check out Truk App https://play.google.com/store/apps/details?id=$packageName',
                          subject: 'Look this awesome transportation app',
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCoupons(CouponModel couponModel) {
    return GestureDetector(
      onTap: () {
        Clipboard.setData(new ClipboardData(text: couponModel.code));
        Fluttertoast.showToast(
          msg: 'Code copied',
          backgroundColor: primaryColor,
          timeInSecForIosWeb: 2,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(133, 45, 145, 1),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${couponModel.code}',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      '${couponModel.name}\n${couponModel.description}',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    Text(
                      '(Click to copy code)',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Stack(
                  children: [
                    SvgPicture.asset(
                      'assets/images/coupon_container.svg',
                      height: 80,
                      width: 80,
                    ),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(75),
                        color: Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          '${couponModel.discountPercent}%\nOFF',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
