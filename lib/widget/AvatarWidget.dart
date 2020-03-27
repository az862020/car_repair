import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/FireUserInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AvatarWidget extends StatefulWidget {
  String userID;
  AvatarWidget(this.userID);

  @override
  State<StatefulWidget> createState() {
    return _AvatarWidget();
  }
}

class _AvatarWidget extends State<AvatarWidget> {
  FireUserInfo creater;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: creater == null || creater.photoUrl == null
              ? AssetImage('assets/images/account_box.png')
              : CloudImageProvider(creater.photoUrl),
        ),
        Container(
          margin: EdgeInsets.only(left: 5),
          child: Text(
            creater == null ? '' : creater.displayName,
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    FireStoreUtils.queryUserinfo(widget.userID).then((snapshot) {
      setState(() {
        FireUserInfo userInfo = FireUserInfo.fromJson(snapshot.data);
        userInfo.uid = snapshot.documentID;
        creater = userInfo;
      });
    });
  }
}
