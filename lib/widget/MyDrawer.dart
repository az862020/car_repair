import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:car_repair/MyImagePick/MyImagePickerPage.dart';
import 'package:car_repair/base/CloudImageCache.dart';
import 'package:car_repair/base/conf.dart';
import 'package:car_repair/favorite/MyFavoritePage.dart';
import 'package:car_repair/publish/MyPublishPage.dart';
import 'package:car_repair/settings/MySettingsPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MyDrawer extends StatefulWidget {
  FirebaseUser _user;

  MyDrawer(this._user);

  @override
  State<StatefulWidget> createState() {
    return _MyDrawerState(_user);
  }
}

class _MyDrawerState extends State<MyDrawer> {
  FirebaseUser _user;

  _MyDrawerState(this._user);

//  final _photoKey = GlobalKey<DrawerHeader>();

  String nickName;
  String Email;
  String photoUrl;

  @override
  void initState() {
    super.initState();
    nickName = _user.displayName ?? _user.email;
    Email = _user.email ?? '';
    photoUrl = _user.photoUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: UserAccountsDrawerHeader(
              accountName: Text('${nickName}'),
              accountEmail: Text('${Email}'),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  gotoPickHead(context);
                },
                child: CircleAvatar(
                  key: ,
                  backgroundImage: photoUrl == null
                      ? AssetImage('assets/images/account_box.png')
                      : CloudImageProvider('$photoUrl'),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              onDetailsPressed: () {
                print('!!! user account tip.');
                gotoAccountSet();
              },
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
          ListTile(
            title: Text('Favorite'),
            leading: new CircleAvatar(
              child: new Icon(Icons.favorite),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyFavoritePage(_user)));
            },
          ),
          ListTile(
            title: Text('Published'),
            leading: new CircleAvatar(
              child: new Icon(Icons.publish),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyPublishPage(_user)));
            },
          ),
          ListTile(
            title: Text('Settings'),
            leading: new CircleAvatar(
              child: new Icon(Icons.settings),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MySettingsPage(_user)));
            },
          ),
        ],
      ),
    );
  }

  gotoPickHead(BuildContext context) async {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyImagePickerPage(
                  user: _user,
                ))).then((user) {
      if (user != null) {
        //todo when i refresh userinfo, should make image download new url.
        bool isG = user.photoUrl.startsWith(Config.AppBucket);
        print('!!! isG $isG');
        if (isG)
          setState(() {
            _user = user;
            photoUrl = _user.photoUrl;
            widget.
          });
      }
    });
  }

  gotoAccountSet() async {
//    UserUpdateInfo info = UserUpdateInfo();
//    info.displayName = 'test123';
//    widget._user.updateProfile(info).then((result) {
//      print('!!! updateProfile success.');
//    });
//    //  userinfo/***uid/doc 进行修改.
//    Firestore.instance
//        .collection('userinfo')
//        .document('${widget._user.uid}')
//        .setData({'testdata': 'test111'});
//
//    // 尝试连接任意目录.
//    Firestore.instance.collection('userinfo');
//
//    //任意目录下添加文档.
//    Firestore.instance.collection('userinfo').add({
//      'test': {'1111': '2222'}
//    });
//
//    // 尝试增量更新.
//    Firestore.instance
//        .document('userinfo/${widget._user.uid}')
//        .get()
//        .then((doc) {
//      doc.data.update('add', (string) {
//        return 'old';
//      }, ifAbsent: () {
//        return 'new';
//      });
//    });
  }
}
