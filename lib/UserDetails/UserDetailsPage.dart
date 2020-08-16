import 'dart:ui';

import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/chat/ChatPage.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:flutter/material.dart';

class UserDetailsPage extends StatelessWidget {
  UserInforEntity userInforEntity;

  UserDetailsPage(this.userInforEntity);

  @override
  Widget build(BuildContext context) {
    return UserDetails(userInforEntity);
  }
}

class UserDetails extends StatefulWidget {
  UserInforEntity userInforEntity;
  String name = '';

  UserDetails(this.userInforEntity) {
    name = userInforEntity.remarkName ?? userInforEntity.displayName;
  }

  @override
  State<StatefulWidget> createState() {
    return UserDetailsState();
  }
}

class UserDetailsState extends State<UserDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.name,
      home: Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context1, isS) {
              return <Widget>[
                SliverAppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context)),
                  expandedHeight: 250.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: EdgeInsetsDirectional.only(bottom: 8),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.userInforEntity.photoUrl ==
                                        null ||
                                    widget.userInforEntity.photoUrl.isEmpty
                                ? AssetImage('assets/images/account_box.png')
                                : CloudImageProvider(
                                    widget.userInforEntity.photoUrl),
                          ),
                          Container(width: 10.0, height: 10.0),
                          Text(widget.name)
                        ],
                      ),
                      background: widget.userInforEntity.photoUrl == null
                          ? Container(color: Colors.blue[300])
                          : Image(
                              image: CloudImageProvider(
                                  widget.userInforEntity.photoUrl),
                              fit: BoxFit.cover)),
                  backgroundColor: Colors.blue,
                ),
              ];
            },
            body: Container(
              color: Colors.grey[300],
              padding: EdgeInsets.only(top: 50.0),
              child: Row(
                children: [
                  IconButton(icon: Icon(Icons.chat), onPressed: () => _goChat)
                ],
              ),
            )),
      ),
    );
  }

  _goChat() {
    FireStoreUtils.getConversation(widget.userInforEntity.uid).then((entity) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatPage(
                  entity, widget.name, widget.userInforEntity.photoUrl)));
    });
  }
}
