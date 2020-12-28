import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MoneySuggestion extends StatelessWidget {
  final String text;
  final bool isSelected;
  MoneySuggestion({this.text, this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? primaryColor : Colors.black),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '₹ $text',
        style: TextStyle(color: isSelected ? primaryColor : Colors.black),
      ),
    );
  }
}
