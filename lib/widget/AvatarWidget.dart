import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/conf.dart';
import 'package:car_repair/entity/FireUserInfo.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/home/ChatPage.dart';
import 'package:car_repair/utils/FireBaseUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// when conversation is null, userID just can be single user's id.
/// when conversation is not null, the id will be the conversation's id.
///   when the conversation type is private ,
///    find user info by id, and get user‘s displayname and photoURL.
///    click should check the conversation had create. my be should create.
///   when the conversation type is group,
///    can get the info in the conversation.

class AvatarWidget extends StatefulWidget {
  String userID;
  ConversationEntity conversation;

  AvatarWidget(this.userID, {ConversationEntity conversation});

  @override
  State<StatefulWidget> createState() {
    return _AvatarWidget();
  }
}

class _AvatarWidget extends State<AvatarWidget> {
  String name;
  String photo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _chatToUser,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: photo.isEmpty
                ? AssetImage('assets/images/account_box.png')
                : CloudImageProvider(photo),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              name ?? '',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    if (widget.conversation == null) {
      //private
      _initByUserID(widget.userID);
    } else {
      // private and group
      if (widget.conversation.chattype == 0) {
        //private
        List<String> ids = widget.conversation.user;
        ids.remove(Config.user.uid);
        _initByUserID(ids.first);
      } else {
        setState(() {
          name = widget.conversation.displayName ?? '';
          photo = widget.conversation.photoUrl ?? '';
        });
      }
    }
  }

  _initByUserID(String uid) {
    FireStoreUtils.queryUserinfo(uid).then((snapshot) {
      setState(() {
        FireUserInfo userInfo = FireUserInfo.fromJson(snapshot.data);
        name = userInfo.displayName;
        photo = userInfo.photoUrl ?? '';
      });
    });
  }

  _chatToUser() {
    if (widget.conversation != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(widget.conversation)));
    } else {
      //private
      FireStoreUtils.getConversation(widget.userID).then((entity) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage(entity)));
      });
    }
  }
}
