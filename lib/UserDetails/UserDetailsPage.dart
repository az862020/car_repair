import 'dart:ui';

import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/chat/ChatPage.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:flutter/cupertino.dart';
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
  FireUserInfoEntity fireuser;

  @override
  void initState() {
    super.initState();
    _queryFireuserInfo();
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 50.0, height: 10.0),
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
              color: Colors.grey[200],
              padding: EdgeInsets.only(top: 10.0, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20),
                  Card(
                    child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Gender is ${fireuser == null || fireuser.sex == null || fireuser.sex.isEmpty ? 'a secret' : fireuser.sex}'),
                          IconButton(
                              icon: Icon(Icons.chat), onPressed: () => _goChat),
                        ],
                      ),
                    ),
                  ),
                  Container(height: 20),
                  Card(
                    child: SizedBox(
                      width: double.infinity,
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                            'Come From ${fireuser == null || fireuser.country == null ? 'the future!' : fireuser.country + fireuser.province}'),
                      ),
                    ),
                  ),
                  Container(height: 20),
                  Card(
                      child: SizedBox(
                          width: double.infinity,
                          child: Container(
                              padding: EdgeInsets.all(15),
                              child: Text(fireuser == null ||
                                      fireuser.signature == null
                                  ? 'This is a lazy person, did not write anything'
                                  : fireuser.signature)))),
                  Container(height: 20),
                  GestureDetector(
                    onTap: () {
                      //todo goto the user's published page.
                      print('!!! go to user\'s published page.');
                    },
                    child: Card(
                      child: Container(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Go to look what has published.'),
                              IconButton(icon: Icon(Icons.keyboard_arrow_right),color: Colors.blue,)
                            ],
                          )),
                    ),
                  ),
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

  void _queryFireuserInfo() {
    FireStoreUtils.queryUserinfo(widget.userInforEntity.uid).then((doc) {
      setState(() {
        fireuser = fireUserInfoEntityFromJson(FireUserInfoEntity(), doc.data());
        fireuser.uid = doc.id;
      });
    });
  }
}
