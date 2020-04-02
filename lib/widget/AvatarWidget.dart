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
  bool donotClick =false;

  AvatarWidget(this.userID, {ConversationEntity conversation, bool donotClick});

  @override
  State<StatefulWidget> createState() {
    return _AvatarWidget();
  }

  String name;
  String photo;

   chatToUser(BuildContext context) {
    if(donotClick|| userID == Config.user.uid) return;
    if (conversation != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(conversation, name)));
    } else {
      //private
      FireStoreUtils.getConversation(userID).then((entity) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatPage(entity, name)));
      });
    }
  }
}

class _AvatarWidget extends State<AvatarWidget> {


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>widget.chatToUser(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: widget.photo==null || widget.photo.isEmpty
                ? AssetImage('assets/images/account_box.png')
                : CloudImageProvider(widget.photo),
          ),
          Container(
            margin: EdgeInsets.only(left: 5),
            child: Text(
              widget.name ?? '',
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
          widget.name = widget.conversation.displayName ?? '';
          widget.photo = widget.conversation.photoUrl ?? '';
        });
      }
    }
  }

  _initByUserID(String uid) {
    FireStoreUtils.queryUserinfo(uid).then((snapshot) {
      setState(() {
        FireUserInfo userInfo = FireUserInfo.fromJson(snapshot.data);
        widget.name = userInfo.displayName;
        widget.photo = userInfo.photoUrl ?? '';
      });
    });
  }


}
