import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final Timestamp time;
  final bool isMe;

  MessageBubble({this.sender, this.text, this.time, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: isMe
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formatDate(time.toDate(), [hh, ':', nn, ':', ss, ' ', am]), style: TextStyle(color: Colors.black54, fontSize: 15)),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius:
                              BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topLeft: Radius.circular(30)),
                          elevation: 5,
                          color: isMe ? Colors.lightBlueAccent : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(
                              text == null ? "" : text,
                              style: TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: TextStyle(color: Colors.black54, fontSize: 15),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          borderRadius: isMe
                              ? BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topLeft: Radius.circular(30))
                              : BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), topRight: Radius.circular(30)),
                          elevation: 5,
                          color: isMe ? Colors.lightBlueAccent : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            child: Text(
                              text == null ? "" : text,
                              style: TextStyle(color: isMe ? Colors.white : Colors.black54, fontSize: 15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(formatDate(time.toDate(), [hh, ':', nn, ' ', am]), style: TextStyle(color: Colors.black54, fontSize: 15)),
                    ),
                  ],
                )
              ],
            ),
    );
  }
}
