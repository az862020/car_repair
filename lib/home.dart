import 'package:car_repair/publish/MyNewPublishPage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'widget/MyDrawer.dart';

class HomePage extends StatelessWidget {
  final String mTitle = 'home';

  final FirebaseUser user;

  const HomePage({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(mTitle),
        ),
        body: HomeState(user),
        drawer: MyDrawer(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.publish),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyNewPublishPage()));
            }),
      ),
    );
  }
}

class HomeState extends StatefulWidget {
  final FirebaseUser user;

  HomeState(this.user);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomeState> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text('ddddddd \n ${widget.user}'),
      ],
    );
  }

  @override
  void initState() {
    Firestore.instance
        .collection('userinfo/${widget.user.uid}')
        .getDocuments()
        .then((snapshot) {});
//    widget.user.updateProfile(userUpdateInfo)
  }
}
