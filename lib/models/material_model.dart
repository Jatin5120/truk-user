import 'dart:convert';

class MaterialModel {
  final String materialName;
  final double quantity;
  final double length;
  final double width;
  final double height;
  MaterialModel({
    this.materialName,
    this.quantity,
    this.length,
    this.width,
    this.height,
  });

  MaterialModel copyWith({
    String materialName,
    double quantity,
    double length,
    double width,
    double height,
  }) {
    return MaterialModel(
      materialName: materialName ?? this.materialName,
      quantity: quantity ?? this.quantity,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'materialName': materialName,
      'quantity': quantity,
      'length': length,
      'width': width,
      'height': height,
    };
  }

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return MaterialModel(
      materialName: map['materialName'],
      quantity: map['quantity'],
      length: map['length'],
      width: map['width'],
      height: map['height'],
    );
  }
}
