import 'package:car_repair/UserDetails/UserDetailsPage.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/entity/conversation_entity.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/utils/UserInfoManager.dart';
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
  bool click;

  String name;
  String photo;
  UserInforEntity userInforEntity;

  AvatarWidget(this.userID, {this.conversation, this.click});

  @override
  State<StatefulWidget> createState() => _AvatarWidgetState();


}

class _AvatarWidgetState extends State<AvatarWidget> {
  @override
  Widget build(BuildContext context) {
    print('!!! avatar new data');
    _initDisplay();
    return GestureDetector(
      onTap: ()  {
        if(widget.click){
          if(widget.conversation==null || widget.conversation.chattype == 0){
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserDetailsPage(widget.userInforEntity)));
          }else{

          }
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: widget.photo == null || widget.photo.isEmpty
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


  _initDisplay(){
    if (widget.conversation == null) {
      //private

      print('!!! private conversation');
      _initByUserID(widget.userID);
    } else {
      // private and group
      if (widget.conversation.chattype == 0) {
        //private

        print('!!! private conversation and is not null.');
        List<String> ids = List();
        ids.addAll(widget.conversation.user);
        print('!!! ids -- $ids');
        ids.remove(Config.user.uid);
        print('!!! ids -- $ids');
        print('!!! ids.first -- ${ids.first}');
        _initByUserID(ids.first);
      } else {
        //group
        setState(() {
          widget.name = widget.conversation.displayName ?? '';
          widget.photo = widget.conversation.photoUrl ?? '';
        });
      }
    }
  }

  _initByUserID(String uid) {
    print('!!! uid -- $uid');
    UserInfoManager.getUserInfo(uid).then((value) => {
          setState(() {
            widget.name = value.displayName;
            widget.photo = value.photoUrl ?? '';
            widget.userInforEntity = value;
          })
        });
  }
}
