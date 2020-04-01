import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/event/StartChatEvent.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  String mTitle = 'CHAT';

  ConversationEntity conversation;
  String conversationName;

  ChatPage(this.conversation, this.conversationName);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(conversationName),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ChatPageState(conversation),
      ),
    );
  }
}

class ChatPageState extends StatefulWidget {
  ConversationEntity conversation;

  ChatPageState(this.conversation);

  @override
  State<StatefulWidget> createState() {
    return _ChatPageState();
  }
}

class _ChatPageState extends State<ChatPageState> {



  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    EventBus().fire(StartChatEvent()); //send a event to home. want show chat.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text('Chat!');
  }


}
