import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/FireUserInfo.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/utils/FireBaseUtils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'GalleryPhotoViewWrapper.dart';

class SquareDetails extends StatelessWidget {
  Square square;

  SquareDetails(this.square);

  int photoIndex = 0;

  @override
  Widget build(BuildContext context1) {
    return MaterialApp(
      title: square.title,
      home: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, isS) {
            return <Widget>[
              SliverAppBar(
                  leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context1)),
                  expandedHeight: 300.0,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    //可以展开区域，通常是一个FlexibleSpaceBar
                    centerTitle: true,
                    title: Text(square.title),
                    background: Hero(
                        tag: '${square.id}',
                        child: GestureDetector(
                          child: PageView.builder(
                            itemCount: square.pics.length,
                            onPageChanged: (i) => photoIndex = i,
                            controller: PageController(initialPage: photoIndex),
                            itemBuilder: (context, index) => Image(
                                image: CloudImageProvider(square.pics[index]),
                                fit: BoxFit.cover),
                          ),
                          onTap: () {
                            preview(context1, square, photoIndex);
                          },
                        )),
                  )),
            ];
          },
          body: SquareDetailsPage(square),
        ),
      ),
    );
  }
}

preview(BuildContext context, Square square, int index) {
  //todo open gallery or play video.
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => GalleryPhotoViewWrapper(
        photos: square,
        initialIndex: index,
      ),
    ),
  );
}

class SquareDetailsPage extends StatefulWidget {
  Square square;

  SquareDetailsPage(this.square);

  @override
  State<StatefulWidget> createState() {
    return _SquareDetailsPage();
  }
}

class _SquareDetailsPage extends State<SquareDetailsPage> {
  FireUserInfo creater;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        Text(
          '${widget.square.pics[0]}',
          style: TextStyle(fontSize: 20.0),
        ),
        Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: creater == null || creater.photoUrl == null
                  ? AssetImage('assets/images/account_box.png')
//                      ? Image.file(File(''))
                  : CloudImageProvider(creater.photoUrl),
            ),
            Text(creater == null ? '' : creater.displayName),
          ],
        )
      ],
    ));
  }

  @override
  void initState() {
    super.initState();
    FireStoreUtils.queryUserinfo(widget.square.userID).then((snapshot) {
      setState(() {
        FireUserInfo userInfo = FireUserInfo.fromJson(snapshot.data);
        userInfo.uid = snapshot.documentID;
        creater = userInfo;
      });
    });
  }
}
