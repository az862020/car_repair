import 'package:car_repair/Account/MyImagePick/MyImagePickerPage.dart';
import 'package:car_repair/Account/MySettingsPage.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/favorite/MyFavoritePage.dart';
import 'package:car_repair/publish/MyPublishPageList.dart';
import 'file:///C:/Users/admin/StudioProjects/car_repair/lib/UserDetails/MyEditDisplayNamePage.dart';
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
                  print('!!! photoUrl : ${Config.user.photoURL}');
                  gotoPickHead(context);
                },
                child: CircleAvatar(
                  backgroundImage: Config.user.photoURL == null
                      ? AssetImage('assets/images/account_box.png')
//                      ? Image.file(File(''))
                      : CloudImageProvider(Config.user.photoURL),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  image: Config.userInfo.backgroundPhoto == null
                      ? null
                      : DecorationImage(
                          image: CloudImageProvider(
                              Config.userInfo.backgroundPhoto),
                          fit: BoxFit.fitWidth)),
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
                      builder: (context) => MyFavoritePage(Config.user.uid)));
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
                      builder: (context) => MyPublishListPage(Config.user.uid)));
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
  }
}
