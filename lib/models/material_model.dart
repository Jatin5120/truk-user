import 'dart:convert';

class MaterialModel {
  final String materialName;
  final String materialType;
  final double quantity;
  final double length;
  final double width;
  final double height;
  final String unit;
  MaterialModel({
    this.materialName,
    this.materialType,
    this.quantity,
    this.length,
    this.width,
    this.height,
    this.unit = "KG",
  });

  MaterialModel copyWith({
    String materialName,
    String materialType,
    double quantity,
    double length,
    double width,
    double height,
    String unit,
  }) {
    return MaterialModel(
      materialName: materialName ?? this.materialName,
      materialType: materialType ?? this.materialType,
      quantity: quantity ?? this.quantity,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'materialName': materialName,
      'materialType': materialType,
      'quantity': quantity,
      'length': length,
      'width': width,
      'height': height,
      'unit': unit
    };
  }

  factory MaterialModel.fromMap(Map<String, dynamic> map) {
    return MaterialModel(
      materialName: map['materialName'],
      materialType: map['materialType'],
      quantity: map['quantity'],
      length: map['length'],
      width: map['width'],
      height: map['height'],
      unit: map['unit'] ?? "KG",
    );
  }
}
