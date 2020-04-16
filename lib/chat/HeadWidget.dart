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
  bool showPhoto;
  bool isRight;

  HeadWidget(this.uid, this.showPhoto, {this.showName = true, this.child, this.isRight});

  @override
  State<StatefulWidget> createState() {
    return _headWidget();
  }
}

class _headWidget extends State<HeadWidget> {
  String photo;
  String name;

  @override
  void initState() {
    if (photo == null) {
      FireStoreUtils.queryUserinfo(widget.uid).then((value) {
        var user = fireUserInfoEntityFromJson(FireUserInfoEntity(), value.data);
        photo = user.photoUrl ?? '';
        name = user.displayName ?? '';
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return !widget.showPhoto
        ? widget.child
        : Row(
            children: <Widget>[
              widget.isRight?getNameWidget():Container(),

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
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          width: 35.0,
                          height: 35.0,
//                          padding: EdgeInsets.all(10.0),
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
              widget.isRight? Container():getNameWidget(),
            ],
          );
  }

  Widget getNameWidget(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        widget.showName && name != null ? Text(name) : Container(),
        widget.child ?? Container()
      ],
    );
  }

}
