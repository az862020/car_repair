

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget{

  Function(String content, int type) sendMessage;
  FocusNode focusNode;
  bool isShowSticker;

  ChatInputWidget(this.sendMessage, this.focusNode, this.isShowSticker);

  @override
  State<StatefulWidget> createState() {
    return _chatInputWidget();
  }

}

class _chatInputWidget extends State<ChatInputWidget>{

  final TextEditingController textEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.image),
                onPressed: getImage,
//                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: getSticker,
//                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
//                  hintStyle: TextStyle(color: greyColor),
                ),
                focusNode: widget.focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => widget.sendMessage(textEditingController.text, 0),
//                color: primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
          new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }

  void getSticker() {
    // Hide keyboard when sticker appear
    widget.focusNode.unfocus();
    setState(() {
      widget.isShowSticker = !widget.isShowSticker;
    });
  }

  void getImage() {


  }

}