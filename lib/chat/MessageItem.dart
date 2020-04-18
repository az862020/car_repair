import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_repair/base/CloudCacheManager.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/chat/HeadWidget.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/fire_message_entity.dart';
import 'package:car_repair/publish/GalleryPhotoViewWrapper.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageItem extends StatefulWidget {
  FireMessageEntity msg;
  ConversationEntity conversation;
  FireMessageEntity lastMsg;
  BuildContext context1;
  bool islast = false;
  bool showTime = false;
  int timeStep = 30 * 60 * 1000;

  MessageItem(this.msg, this.conversation, this.lastMsg, this.context1) {
    if (lastMsg == null || lastMsg.sendID != msg.sendID) islast = true;
    if (lastMsg == null || msg.time - lastMsg.time > timeStep) showTime = true;
  }

  @override
  State<StatefulWidget> createState() {
    return _messageItemState();
  }
}

class _messageItemState extends State<MessageItem> {
  @override
  Widget build(BuildContext context) {
    return buildItem(widget.msg.sendID == Config.user.uid, context);
  }

  Widget buildItem(bool isRight, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        widget.showTime
            ? Container(
                child: Text(
                  DateUtil.formatDate(
                      DateTime.fromMillisecondsSinceEpoch(widget.msg.time)),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(top: 20.0, bottom: 5.0),
              )
            : Container(),
        Row(
          mainAxisAlignment:
              isRight ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            HeadWidget(widget.msg.sendID, widget.showTime,
                isRight: isRight,
                child: Padding(
                    padding: EdgeInsets.all(5.0),
                    child: getMessageContentWidget(isRight, context))),
          ],
        )
      ],
    );
  }

  Widget getMessageContentWidget(bool isRight, BuildContext context) {
    switch (widget.msg.type) {
      case 0:
        return getTextWidget(isRight);
      case 1:
        return getPhotoWidget(isRight, context);
      case 2:
        return getStickWidget(isRight);
    }
  }

  Widget getTextWidget(bool isRight) {
    return Container(
      alignment: isRight ? Alignment.centerRight : Alignment.centerLeft,
      width: 200.0,
      child: Container(
        child: Text(
          widget.msg.content,
          style: TextStyle(color: Colors.black),
        ),
        padding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
        decoration: BoxDecoration(
            color: isRight ? Colors.blue[300] : Colors.white,
            borderRadius: BorderRadius.circular(8.0)),
      ),
    );
  }

  Widget getPhotoWidget(bool isRight, BuildContext context) {
    return Container(
      child: FlatButton(
        child: Material(
          child: Hero(
            tag: widget.msg.id,
            child: CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                width: 200.0,
                height: 200.0,
                padding: EdgeInsets.all(70.0),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Material(
                child: Image.asset(
                  'images/img_not_available.jpg',
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              imageUrl: widget.msg.content,
              cacheManager: CloudCacheManager(),
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        onPressed: () {
          Navigator.push(
              widget.context1,
              MaterialPageRoute(
                  builder: (context) => GalleryPhotoViewWrapper(
                        photos: [widget.msg.content],
                        heorID: widget.msg.id,
                      )));
        },
        padding: EdgeInsets.all(0),
      ),
    );
  }

  Widget getStickWidget(bool isRight) {
    return Container(
      child: new Image.asset(
        'assets/emoji/${widget.msg.content}.gif',
        width: 80.0,
        height: 80.0,
        fit: BoxFit.cover,
      ),
      margin: EdgeInsets.only(
          bottom: widget.islast && !isRight ? 20.0 : 10.0, right: 10.0),
    );
  }
}
