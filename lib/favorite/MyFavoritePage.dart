import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/user_infor_entity.dart';
import 'package:car_repair/generated/json/user_infor_entity_helper.dart';
import 'package:car_repair/widget/MoreListWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class MyFavoritePage extends StatelessWidget {
  final String mTitle = 'MyFavorite';
  final String uid;

  MyFavoritePage(this.uid);

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
        body: FavoritePage(uid),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.cloud_download),
            onPressed: () {
              print('float button on tip.');
              //TODO down load the favorite photo/video.


            }),
      ),
    );
  }
}

class FavoritePage extends StatefulWidget {
  String uid;
  FavoritePage(this.uid);

  @override
  State<StatefulWidget> createState() {
    return FavoriteState();
  }
}

class FavoriteState extends State<FavoritePage>{
  @override
  Widget build(BuildContext context) {
    return MyFavorateList(widget.uid);
  }
}

class MyFavorateList extends MoreListWidget {
  String uid;
  MyFavorateList(this.uid);

  @override
  DocumentReference getListMap() {
    return FireStoreUtils.getMyFavoratedList(uid);
  }
}



class _FavoriteState extends State<FavoritePage> {
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
