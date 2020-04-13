import 'package:car_repair/Account/MyImagePick/MyImagePickerPage.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/conf.dart';
import 'package:car_repair/favorite/MyFavoritePage.dart';
import 'package:car_repair/publish/MyPublishPageList.dart';
import 'file:///C:/Users/admin/StudioProjects/car_repair/lib/Account/MySettingsPage.dart';
import 'package:car_repair/Account/MyEditDisplayNamePage.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
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
                  Text('${Config.user.displayName ?? Config.user.email}'),
              accountEmail: Text('${Config.user.email}'),
              currentAccountPicture: GestureDetector(
                onTap: () {
                  print('!!! photoUrl : ${Config.user.photoUrl}');
                  gotoPickHead(context);
                },
                child: CircleAvatar(
                  backgroundImage: Config.user.photoUrl == null
                      ? AssetImage('assets/images/account_box.png')
//                      ? Image.file(File(''))
                      : CloudImageProvider(Config.user.photoUrl),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              onDetailsPressed: () {
                print('!!! user account tip.');
                gotoAccountSet(context);
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
                      builder: (context) => MyFavoritePage(Config.user)));
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
                      builder: (context) => MyPublishListPage(Config.user)));
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
                      builder: (context) => MySettingsPage(Config.user)));
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
                  user: Config.user,
                ))).then((user) {
      if (user != null) {
        // when i refresh userinfo, should make image download new url.
        bool isG = user.photoUrl.startsWith(Config.AppBucket);
        print('!!! isG $isG  ${user.photoUrl}');
        if (isG)
          setState(() {
            Config.user = user;
          });
      }
    });
  }

  gotoAccountSet(BuildContext context) async {
    Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyEditDisplayNamePage()))
        .then((any) {
      setState(() {});
    });

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
