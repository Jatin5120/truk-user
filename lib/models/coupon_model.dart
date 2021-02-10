import 'package:cloud_firestore/cloud_firestore.dart';

class CouponModel {
  String id;
  String code;
  String description;
  String name;
  int discountPercent;
  int expiry;
  List<int> pincode;
  int minimum;
  CouponModel({
    this.id,
    this.code,
    this.description,
    this.name,
    this.discountPercent,
    this.expiry,
    this.pincode,
    this.minimum,
  });

  CouponModel copyWith({
    String id,
    String code,
    String description,
    String name,
    int discountPercent,
    int expiry,
    List<int> pincode,
    int minimum,
  }) {
    return CouponModel(
      id: id ?? this.id,
      code: code ?? this.code,
      description: description ?? this.description,
      name: name ?? this.name,
      discountPercent: discountPercent ?? this.discountPercent,
      expiry: expiry ?? this.expiry,
      pincode: pincode ?? this.pincode,
      minimum: minimum ?? this.minimum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'name': name,
      'discountPercent': discountPercent,
      'expiry': expiry,
      'pincode': pincode,
      'minimum': minimum,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return CouponModel(
      id: map['id'],
      code: map['code'],
      description: map['description'],
      name: map['name'],
      discountPercent: map['discountPercent'],
      expiry: map['expiry'],
      minimum: map['minimum'],
      pincode: List<int>.from(map['pincode']),
    );
  }

  factory CouponModel.fromSnap(QueryDocumentSnapshot map) {
    if (map == null) return null;

    return CouponModel(
      id: map.id,
      code: map.get('code'),
      description: map.get('description'),
      name: map.get('name'),
      discountPercent: map.get('discountPercent'),
      expiry: map.get('expiry'),
      minimum: map.get('min'),
      pincode: List<int>.from(
        map.get('pincode'),
      ),
    );
  }
}
