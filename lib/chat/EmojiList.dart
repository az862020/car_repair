import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:car_repair/chat/Emoji.dart';


class EmojiList extends StatefulWidget {
  Emoji emoji;
  Function(String content, int type) sendMessage;

  EmojiList(this.emoji, this.sendMessage);

  @override
  State<StatefulWidget> createState() {
    return _emojiListState();
  }
}

class _emojiListState extends State<EmojiList> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, childAspectRatio: 1.0),
        itemCount: widget.emoji.size,
        itemBuilder: (context, index) {
          return _getEmojiItem(index);
        });
  }

  Widget _getEmojiItem(int index) {
    String emojiItem = '${widget.emoji.name.toLowerCase()}-${index + 1}';
    return FlatButton(
        onPressed: () {
          widget.sendMessage(emojiItem, 2);
        },
        child: Image.asset(
          'assets/emoji/$emojiItem.gif',
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ));
  }
}
