import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:trukapp/models/material_model.dart';

enum Status {
  ACCEPTED,
  REJECTED,
  PENDING,
}

class QuoteModel {
  String uid;
  String mobile;
  LatLng source;
  LatLng destination;
  String price;
  List<MaterialModel> materials;
  String truk;
  String pickupDate;
  int bookingId;
  String status;
  int bookingDate;
  bool insured;
  String load;
  String mandate;
  String trukName;
  QuoteModel(
      {this.uid,
      this.mobile,
      this.source,
      this.destination,
      this.materials,
      this.truk,
      this.pickupDate,
      this.bookingId,
      this.bookingDate,
      this.insured,
      this.load,
      this.mandate,
      this.price,
      this.status = 'PENDING',
      this.trukName = 'Eicher'});

  QuoteModel copyWith(
      {String uid,
      String mobile,
      LatLng source,
      LatLng destination,
      List<MaterialModel> materials,
      String truk,
      String pickupDate,
      int bookingId,
      int bookingDate,
      bool insured,
      String load,
      String mandate,
      String status,
      String trukName,
      String price}) {
    return QuoteModel(
        uid: uid ?? this.uid,
        mobile: mobile ?? this.mobile,
        source: source ?? this.source,
        destination: destination ?? this.destination,
        materials: materials ?? this.materials,
        truk: truk ?? this.truk,
        pickupDate: pickupDate ?? this.pickupDate,
        bookingId: bookingId ?? this.bookingId,
        bookingDate: bookingDate ?? this.bookingDate,
        insured: insured ?? this.insured,
        load: load ?? this.load,
        mandate: mandate ?? this.mandate,
        status: status ?? this.source,
        trukName: trukName ?? this.trukName,
        price: price ?? this.price);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'mobile': mobile,
      'source': stringToLatlng(source.toString()),
      'destination': stringToLatlng(destination.toString()),
      'materials': materials?.map((x) => x?.toMap())?.toList(),
      'truk': truk,
      'pickupDate': pickupDate,
      'bookingId': bookingId,
      'bookingDate': bookingDate,
      'insured': insured,
      'load': load,
      'mandate': mandate,
      'price': price,
      'status': status,
      'trukName': trukName
    };
  }

  factory QuoteModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return QuoteModel(
        uid: map['uid'],
        mobile: map['mobile'],
        source: stringToLatlng(map['source']),
        destination: stringToLatlng(map['destination']),
        materials: List<MaterialModel>.from(map['materials']?.map((x) => MaterialModel.fromMap(x))),
        truk: map['truk'],
        pickupDate: map['pickupDate'],
        bookingId: map['bookingId'],
        bookingDate: map['bookingDate'],
        insured: map['insured'],
        load: map['load'],
        mandate: map['mandate'],
        price: map['price'],
        trukName: map['trukName'],
        status: map['status']);
  }

  factory QuoteModel.fromSnapshot(QueryDocumentSnapshot map) {
    if (map == null) return null;

    return QuoteModel(
        uid: map.get('uid'),
        mobile: map.get('mobile'),
        source: stringToLatlng(map.get('source')),
        destination: stringToLatlng(map.get('destination')),
        materials: List<MaterialModel>.from(map.get('materials')?.map((x) => MaterialModel.fromMap(x))),
        truk: map.get('truk'),
        pickupDate: map.get('pickupDate'),
        bookingId: map.get('bookingId'),
        bookingDate: map.get('bookingDate'),
        insured: map.get('insured'),
        load: map.get('load'),
        mandate: map.get('mandate'),
        price: map.get('price'),
        trukName: map.get('trukName'),
        status: map.get('status'));
  }

  static LatLng stringToLatlng(String coordindates) {
    List<String> splitted = coordindates.split(',');
    return LatLng(double.parse(splitted[0]), double.parse(splitted[1]));
  }
}
