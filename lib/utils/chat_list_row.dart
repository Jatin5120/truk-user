import 'package:flutter/material.dart';
import '../models/chatting_list_model.dart';

class ChatListRow extends StatelessWidget {
  final ChattingListModel model;
  const ChatListRow({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              width: 60,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/no_data.png',
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booking Id : ${model.bookingId}',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Vendor Id : ${model.vendorId}',
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'Time : ${model.time}',
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
