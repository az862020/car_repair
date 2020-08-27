import 'package:car_repair/base/Config.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../chat/ChatPage.dart';

class ConversationCard extends StatefulWidget {
  ConversationEntity entity;

  ConversationCard(this.entity);

  @override
  State<StatefulWidget> createState() {
    return _ConversationCardState();
  }
}

class _ConversationCardState extends State<ConversationCard> {
  var key = GlobalKey<AvatarWidgetState>();

  @override
  Widget build(BuildContext context) {
    print('!!! card widget build.');
    String lastContent;
    if (widget.entity.lastContent == null ||
        widget.entity.lastContent.isEmpty) {
      lastContent = '';
    } else {
      lastContent = widget.entity.lastSenderID == Config.user.uid
          ? widget.entity.lastContent
          : widget.entity.lastdisplayName + " : " + widget.entity.lastContent;
    }
    print('!!! conversation is null ${widget.entity == null}');
    return GestureDetector(
      onTap: () {
        key.currentState.onClick(context);
      },
      child: Card(
        elevation: 10.0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  AvatarWidget(widget.entity.id, conversation: widget.entity, key: key),
                  Text(
                    '${DateUtil.formatDate(DateTime.fromMillisecondsSinceEpoch(widget.entity.updateTime))}',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 45),
                  child: Text(
                    lastContent,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
