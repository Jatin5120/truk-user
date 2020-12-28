import 'package:flutter/material.dart';

class NoDataPage extends StatelessWidget {
  final String text;

  const NoDataPage({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/images/no_data.png'),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            '$text',
            style: TextStyle(color: Colors.grey, fontSize: 20),
          ),
        ),
      ],
    );
  }
}
