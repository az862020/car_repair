import 'dart:io';
import 'dart:typed_data';

import 'package:car_repair/publish/SquareDetails.dart';
import 'package:car_repair/base/CloudImageCache.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/publish/MyNewPublishPage.dart';
import 'package:car_repair/widget/SquareCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'base/CloudImageProvider.dart';
import 'widget/MyDrawer.dart';

import 'package:http/http.dart' as http;

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
    return StreamBuilder<QuerySnapshot>(
      stream: FireStoreUtils.querySquareByType('default'),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
//    return ListView.builder(itemBuilder: (context, i) {
////      if (i >= snapshot.length) return null;
////      return _buildListItem(context, snapshot[i]);
////    });
    return ListView(
      children: snapshot.map((data) => _buildListItem(context, data)).toList(),
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final square = Square.fromJson(data.data);
    square.id = data.documentID;

    return Padding(
      key: ValueKey(square.id),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SquareCard(square, (square) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SquareDetails(square)));
        data.reference.updateData({'click': FieldValue.increment(1)});
      }),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
