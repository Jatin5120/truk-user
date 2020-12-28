import 'package:flutter/material.dart';

final Color primaryColor = Color(0xffFF7101);
final String testApiKey = 'rzp_test_mJh9QWD7lZ8ToY';

List<Map<String, dynamic>> walkthroughList = [
  {
    'title': 'Live Transport Market',
    'subtitle': 'Book Trucks, Trailers & Tankers from live market and find best deals',
    'image': AssetImage('assets/images/walk_1.png')
  },
  {
    'title': 'One Tap Online Tracking',
    'subtitle': 'Find your Truck on Finger tip and Track online from Start to End.',
    'image': AssetImage('assets/images/walk_2.png')
  },
  {
    'title': 'Partial Load Services',
    'subtitle': 'Get your load reach the destination in time without paying for the entire Truk.',
    'image': AssetImage('assets/images/walk_3.png')
  },
];
List<String> mandateType = ['On-Demand', 'Lease'];
List<String> loadType = ['Partial TruK', 'Full TruK'];
List<String> trukType = ['Open TruK', 'Closed TruK'];
