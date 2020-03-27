
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/FireUserInfo.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/widget/CardBottomIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'GalleryPhotoViewWrapper.dart';

class SquareDetails extends StatelessWidget {
  Square square;
  String squarePath;
  SquareDetails(this.square, this.squarePath);

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
          body: SquareDetailsPage(square, squarePath),
        ),
      ),
    );
  }
}

preview(BuildContext context, Square square, int index) {
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
  String squarePath;
  SquareDetailsPage(this.square, this.squarePath);

  @override
  State<StatefulWidget> createState() {
    return _SquareDetailsPage();
  }
}

class _SquareDetailsPage extends State<SquareDetailsPage> {
  FireUserInfo creater;

  final commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSend = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: <Widget>[
        CardBottomIcon(widget.square, () => _likeClick()),
        Form(
            key: _formKey,
            child: TextFormField(
              controller: commentController,
              validator: (string) {
                if (string.isEmpty) return 'commnet can\'t be empty.';
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Enter your commnet',
                  hintText: 'Just can not be empty, input any you want say.',
                  icon: Icon(Icons.add_comment)),
            )),
        RaisedButton(
          color: Colors.blue[400],
          child: Container(
            child: Text('send'),
          ),
          onPressed: () => _sendComment(),
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
    FireStoreUtils.getCommentsByPath(widget.squarePath).then((query){
      List<DocumentSnapshot> list = query.documents;
      print('!!! documents size ${list.length}');
      for(DocumentSnapshot snapshot in list){
        print('!!!!! ${snapshot.data} ');
      }
    });
  }

  _likeClick() {
    print('!!! likeClick!');
  }


  _sendComment() {
    if(!isSend && _formKey.currentState.validate()){
      print('!!! _sendComment');
      FireStoreUtils.addComment(widget.squarePath, commentController.text);
    }
  }
}
