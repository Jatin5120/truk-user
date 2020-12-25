import 'package:flutter/material.dart';
import 'package:trukapp/utils/constants.dart';

class Support extends StatefulWidget {
  @override
  _SupportState createState() => _SupportState();
}

class _SupportState extends State<Support> {
  TextStyle senderStyle = TextStyle(color: Colors.black, fontSize: 16);
  TextStyle receiverStyle = TextStyle(color: Colors.white, fontSize: 16);
  Size get size => MediaQuery.of(context).size;

  Widget messageBubble({String message, String time, bool sender}) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      alignment: sender ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment:
            sender ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (sender)
            Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  '$time',
                  style: TextStyle(fontSize: 12),
                )),
          Flexible(
            flex: 1,
            child: Container(
              width: size.width * 0.6,
              child: Material(
                elevation: 3.0,
                shadowColor: Colors.grey,
                type: MaterialType.canvas,
                borderRadius: sender
                    ? BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      )
                    : BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                child: ClipRRect(
                    borderRadius: sender
                        ? BorderRadius.only(
                            topLeft: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          )
                        : BorderRadius.only(
                            topRight: Radius.circular(15),
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 20, bottom: 20),
                      // height: 60,
                      alignment: Alignment.center,
                      child: Text('$message',
                          style: sender ? senderStyle : receiverStyle,
                          overflow: TextOverflow.visible),
                      decoration: BoxDecoration(
                        color: sender ? Colors.white : primaryColor,
                      ),
                    )),
              ),
            ),
          ),
          if (!sender)
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(
                '$time',
                style: TextStyle(fontSize: 12),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                messageBubble(
                  message: 'Hi, How can I help you?',
                  sender: false,
                  time: '20:01',
                ),
                messageBubble(
                    message: 'Can I know fare for truk?',
                    sender: true,
                    time: '20:05')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
