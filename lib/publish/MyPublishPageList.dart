import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyPublishListPage extends StatelessWidget {
  final String mTitle = 'MyPublished';
  final FirebaseUser _user;

  MyPublishListPage(this._user);

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
        body: PublishListPage(_user),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.cloud_upload),
            onPressed: () {
              print('float button on tip.');
              //TODO XO up load and publish photo/video.
            }),
      ),
    );
  }
}

class PublishListPage extends StatefulWidget {
  final FirebaseUser _user;

  PublishListPage(this._user);

  @override
  State<StatefulWidget> createState() {
    return _PublisthListState();
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
