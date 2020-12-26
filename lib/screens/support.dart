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
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 8),
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
                          left: 10, right: 10, top: 15, bottom: 15),
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

  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support'),
      ),
      body: LayoutBuilder(
        builder: (context, constraint) => Container(
          child: Container(
            width: size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Flexible(
                  flex: 9,
                  child: ListView(
                    children: [
                      messageBubble(
                        message: 'Hi, How can I help you?',
                        sender: false,
                        time: '20:01',
                      ),
                      messageBubble(
                          message: 'Can I know fare for truk?',
                          sender: true,
                          time: '20:05'),
                    ],
                  ),
                ),
                Flexible(
                  flex: 0,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: size.width, maxHeight: 100),
                    child: IntrinsicHeight(
                      child: TextFormField(
                        expands: true,
                        cursorColor: Colors.black,
                        controller: _messageController,
                        maxLines: null,
                        minLines: null,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.send,
                                color: primaryColor,
                              ),
                              onPressed: () {},
                            ),
                            prefixIcon: IconButton(
                              icon: Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              onPressed: () {},
                            ),
                            hintText: 'Add text to this message',
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.black)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.zero,
                                borderSide: BorderSide(color: Colors.black))),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
