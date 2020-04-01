import 'package:car_repair/entity/conversation_entity.dart';
import 'package:flutter/cupertino.dart';

class ChatPage extends StatelessWidget {
  ConversationEntity conversation;

  ChatPage(this.conversation);

  @override
  Widget build(BuildContext context) {
    return ChatPageState(conversation);
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
  Widget build(BuildContext context) {
    return Text('Chat!');
  }
}
