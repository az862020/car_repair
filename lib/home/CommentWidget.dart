
import 'package:car_repair/entity/comment_entity.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentWidget extends StatefulWidget{
  CommentEntity entity;

  CommentWidget(this.entity);

  @override
  State<StatefulWidget> createState() => _CommentWidgetState();

}

class _CommentWidgetState extends State<CommentWidget>{
  GlobalKey key = GlobalKey<AvatarWidgetState>();


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AvatarWidget(widget.entity.userID, click: true, key: key),
              Text(
                '${DateUtil.formatDate(DateTime.fromMillisecondsSinceEpoch(widget.entity.time))}',
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                widget.entity.content,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

}