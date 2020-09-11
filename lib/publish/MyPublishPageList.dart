import 'package:car_repair/base/Config.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/publish/MyNewPublishPage.dart';
import 'package:car_repair/widget/MoreListWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyPublishListPage extends StatelessWidget {
  final String mTitle = 'Published List';
  final String uid;

  MyPublishListPage(this.uid);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(mTitle),
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: PublishListPage(uid),
        floatingActionButton: uid != Config.userInfo.uid
            ? null
            : FloatingActionButton(
                child: Icon(Icons.cloud_upload),
                onPressed: () {
                  print('float button on tip.');
                  //TODO XO up load and publish photo/video.
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyNewPublish()));
                }),
      ),
    );
  }
}

class PublishListPage extends StatefulWidget {
  final String uid;
  PublishListPage(this.uid);

  @override
  State<StatefulWidget> createState() {
    return PublishListState();
  }
}

class PublishListState extends State<PublishListPage>{
  @override
  Widget build(BuildContext context) {
    return MyPublishList(widget.uid);
  }
}

class MyPublishList extends MoreListWidget {
  final String uid;
  MyPublishList(this.uid);

  @override
  DocumentReference getListMap() {
    return FireStoreUtils.getMySquareList(uid);
  }
}



class _PublisthListState extends State<PublishListPage> {
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: 8,
      itemBuilder: (BuildContext context, int index) => new Container(
          color: Colors.green,
          child: new Center(
            child: new CircleAvatar(
              backgroundColor: Colors.white,
              child: new Text('$index'),
            ),
          )),
      staggeredTileBuilder: (int index) =>
          new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}
