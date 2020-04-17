import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_repair/base/CloudCacheManager.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:car_repair/base/Config.dart';

class HeadWidget extends StatefulWidget {
  String uid;
  bool showName;
  Widget child;
  bool showPhoto;
  bool isRight;

  HeadWidget(this.uid, this.showPhoto,
      {this.showName = true, this.child, this.isRight = false});

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
        ? Padding(
            padding: EdgeInsets.only(left: Config.avatarWidth, right: Config.avatarWidth),
            child: widget.child,
          )
        : Row(
            mainAxisAlignment: widget.isRight
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              widget.isRight ? getNameWidget() : Container(),
              Material(
                child: photo == null || photo.isEmpty
                    ? Image.asset(
                        'assets/images/account_box.png',
                        width: Config.avatarWidth,
                        height: Config.avatarWidth,
                      )
                    : CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                          width: Config.avatarWidth,
                          height: Config.avatarWidth,
//                          padding: EdgeInsets.all(10.0),
                        ),
                        imageUrl: photo,
                        cacheManager: CloudCacheManager(),
                        width: Config.avatarWidth,
                        height: Config.avatarWidth,
                        fit: BoxFit.cover,
                      ),
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
                clipBehavior: Clip.hardEdge,
              ),
              widget.isRight ? Container() : getNameWidget(),
            ],
          );
  }

  Widget getNameWidget() {
    return Column(
      crossAxisAlignment:
          widget.isRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: <Widget>[
        widget.showName && name != null
            ? Container(
                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                child: Text(
                  name,
                ),
              )
            : Container(),
        widget.child ?? Container()
      ],
    );
  }
}
