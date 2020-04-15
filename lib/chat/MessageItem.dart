import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_repair/base/CloudCacheManager.dart';
import 'package:car_repair/base/conf.dart';
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
  bool islast;

  MessageItem(this.msg, this.conversation, this.islast);

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
    if (widget.msg.sendID == Config.user.uid) {
      // Right (my message)
      return Row(
        children: <Widget>[
          widget.msg.type == 0
              // Text
              ? getTextWidget(true)
              : widget.msg.type == 1
                  // Image
                  ? getPhotoWidget(isRight, context)
                  // Sticker
                  : Container(
                      child: new Image.asset(
                        'images/${widget.msg.content}.gif',
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                      ),
                      margin: EdgeInsets.only(
                          bottom: widget.islast && isRight ? 20.0 : 10.0,
                          right: 10.0),
                    ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    } else {
      // Left (peer message)
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                widget.islast && !isRight
                    ? HeadWidget(widget.msg.sendID, showName: true)
                    : Container(width: 35.0),
                widget.msg.type == 0
                    ? getTextWidget(false)
                    : widget.msg.type == 1
                        ? getPhotoWidget(isRight, context)
                        : Container(
                            child: new Image.asset(
                              'images/${widget.msg.content}.gif',
                              width: 100.0,
                              height: 100.0,
                              fit: BoxFit.cover,
                            ),
                            margin: EdgeInsets.only(
                                bottom: widget.islast && !isRight ? 20.0 : 10.0,
                                right: 10.0),
                          ),
              ],
            ),

            // Time
            widget.islast && !isRight
                ? Container(
                    child: Text(
                      DateUtil.formatDate(
                          DateTime.fromMillisecondsSinceEpoch(widget.msg.time)),
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                : Container()
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  Widget getTextWidget(bool isRight) {
    return Container(
      child: Text(
        widget.msg.content,
        style: TextStyle(color: Colors.black),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: 200.0,
      decoration: BoxDecoration(
          color: isRight ? Colors.blue[300] : Colors.white,
          borderRadius: BorderRadius.circular(8.0)),
      margin: EdgeInsets.only(
          bottom: widget.islast && isRight ? 20.0 : 10.0,
          right: isRight ? 0 : 10.0,
          left: isRight ? 10.0 : 0),
    );
  }

  Widget getPhotoWidget(bool isRight, BuildContext context) {
    return Container(
            child: FlatButton(
              child: Material(
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
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                clipBehavior: Clip.hardEdge,
              ),
              onPressed: () {
                List<String> photo = [widget.msg.content];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GalleryPhotoViewWrapper(
                              photos: photo,
                            )));
              },
              padding: EdgeInsets.all(0),
            ),
            margin: EdgeInsets.only(
                bottom: widget.islast && isRight ? 20.0 : 10.0, right: 10.0, left: 10.0),
          );
  }
}
