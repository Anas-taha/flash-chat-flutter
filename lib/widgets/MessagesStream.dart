import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/widgets/MessagesBubble.dart';
import 'package:flutter/material.dart';

class MessagesStream extends StatelessWidget {
  MessagesStream(this.stream, {this.scrollController, this.isMe, this.loggedInUser});
  final stream;
  final scrollController;
  final bool isMe;
  final String loggedInUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ));
          }
          final messages = snapshot.data.docs.reversed;
          List<MessageBubble> messageBubbles = [];

          for (var message in messages) {
            final messageText = message.get('text');
            final messageSender = message.get('sender');
            final messageTime = message.get('time');
            final currentUser = loggedInUser;

            final messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              time: messageTime,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageWidget);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              children: messageBubbles,
            ),
          );
        });
  }
}
