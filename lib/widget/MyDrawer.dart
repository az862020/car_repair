import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:car_repair/favorite/MyFavoritePage.dart';
import 'package:car_repair/publish/MyPublishPage.dart';
import 'package:car_repair/settings/MySettingsPage.dart';
import 'package:car_repair/MyImagePick/MyImagePickerPage.dart';

class MyDrawer extends StatefulWidget {
  FirebaseUser _user;

  MyDrawer(this._user);

  @override
  State<StatefulWidget> createState() {
    return _MyDrawerState();
  }
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: UserAccountsDrawerHeader(
              accountName:
                  Text('${widget._user.displayName ?? widget._user.email}'),
              accountEmail: Text('${widget._user.email ?? ''}'),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  gotoPickHead();
                },
                child: CircleAvatar(
                  backgroundImage: widget._user.displayName == null
                      ? AssetImage('assets/images/account_box.png')
                      : CachedNetworkImageProvider(widget._user.photoUrl),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              onDetailsPressed: () {
                print('!!! user account tip.');
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
                      builder: (context) => MyFavoritePage(widget._user)));
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
                      builder: (context) => MyPublishPage(widget._user)));
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
                      builder: (context) => MySettingsPage(widget._user)));
            },
          ),
        ],
      ),
    );
  }

  gotoPickHead() async {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyImagePickerPage()))
        .then((file) {
      if (file != null) {
        File img = file;
        print('!!! draw ${img.path} ');
        //TODO get file and upload. and change the head photo.

      }
    });
  }
}
