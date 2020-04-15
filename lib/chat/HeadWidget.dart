import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_repair/base/CloudCacheManager.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HeadWidget extends StatefulWidget {
  String uid;
  bool showName;
  Widget child;

  HeadWidget(this.uid, {this.showName = false, this.child});

  @override
  State<StatefulWidget> createState() {
    return _headWidget(uid, showName: showName, child: child);
  }
}

class _headWidget extends State<StatefulWidget> {
  String uid;
  bool showName;
  Widget child;

  _headWidget(this.uid, {this.showName = false, this.child});

  String photo;
  String name;

  @override
  void initState() {
    if (photo == null) {
      FireStoreUtils.queryUserinfo(uid).then((value) {
        var user = fireUserInfoEntityFromJson(FireUserInfoEntity(), value.data);
        photo = user.photoUrl ?? '';
        name = user.displayName ?? '';
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Material(
          child: photo == null || photo.isEmpty
              ? Image.asset(
                  'assets/images/account_box.png',
                  width: 35.0,
                  height: 35.0,
                )
              : CachedNetworkImage(
                  placeholder: (context, url) => Container(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    width: 35.0,
                    height: 35.0,
                    padding: EdgeInsets.all(10.0),
                  ),
                  imageUrl: photo,
                  cacheManager: CloudCacheManager(),
                  width: 35.0,
                  height: 35.0,
                  fit: BoxFit.cover,
                ),
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
          clipBehavior: Clip.hardEdge,
        ),

//        CircleAvatar(
//          backgroundImage: photo == null || photo.isEmpty
//              ? AssetImage('assets/images/account_box.png')
//              : CloudImageProvider(photo),
//        ),
        Column(
          children: <Widget>[
            showName && name != null ? Text(name) : Container(),
            child ?? Container()
          ],
        )
      ],
    );
  }
}
