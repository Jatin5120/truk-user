import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationHelper {
  final User user = FirebaseAuth.instance.currentUser;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void registerNotification() async {
    await firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        //})(onMessage: (Map<String, dynamic> message) {
        print('onMessage: $message');
        AndroidNotification androidNotification = message.notification?.android;
        AppleNotification appleNotification = message.notification?.apple;
        if (message.notification != null &&
            (Platform.isAndroid ? androidNotification != null : appleNotification != null)) {
          Platform.isAndroid ? showNotification(androidNotification) : showNotification(appleNotification);
        }
      },
      // onResume: (Map<String, dynamic> message) {
      //   print('onResume: $message');
      //   return;
      // }, onLaunch: (Map<String, dynamic> message) {
      //   print('onLaunch: $message');
      //   return;
      // }
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      //Navigator.pushNamed(context, '/message', arguments: MessageArguments(message, true));
    });
    firebaseMessaging.getToken().then((token) {
      //print('token: $token');
      FirebaseFirestore.instance.collection('Users').doc(user.uid).update({'token': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void configLocalNotification() {
    var initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = IOSInitializationSettings();
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      Platform.isAndroid ? 'com.augmentik.trukapp' : 'com.augmentik.trukappios',
      'TruK',
      'Notification from TruK App',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.high,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(iOS: iOSPlatformChannelSpecifics, android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      message['title'].toString(),
      message['body'].toString(),
      platformChannelSpecifics,
      payload: json.encode(message),
    );
  }
}
