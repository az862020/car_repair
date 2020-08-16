import 'package:car_repair/UserDetails/UserDetailsPage.dart';
import 'package:car_repair/base/CloudImageProvider.dart';
import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/base/Config.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/entity/comment_entity.dart';
import 'package:car_repair/entity/fire_user_info_entity.dart';
import 'package:car_repair/generated/json/comment_entity_helper.dart';
import 'package:car_repair/generated/json/fire_user_info_entity_helper.dart';
import 'package:car_repair/widget/AvatarWidget.dart';
import 'package:car_repair/widget/BottomMore.dart';
import 'package:car_repair/widget/CardBottomIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'GalleryPhotoViewWrapper.dart';

class SquareDetails extends StatelessWidget {
  Square square;
  DocumentReference squareReference;

  SquareDetails(this.square, this.squareReference);

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
          body: SquareDetailsPage(square, squareReference),
        ),
      ),
    );
  }

  preview(BuildContext context, Square square, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          photos: square.pics,
          heorID: square.id,
          initialIndex: index,
        ),
      ),
    );
  }
}

class SquareDetailsPage extends StatefulWidget {
  Square square;
  DocumentReference squareReference;

  SquareDetailsPage(this.square, this.squareReference);

  @override
  State<StatefulWidget> createState() {
    return _SquareDetailsPage();
  }
}

class _SquareDetailsPage extends State<SquareDetailsPage> {
  FireUserInfoEntity creater;

  final commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int commentStep = 20;
  bool isSend = false;
  bool isLoading = false;
  bool isEnd = false;
  List<DocumentSnapshot> dataList = List();
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    FireStoreUtils.queryUserinfo(widget.square.userID).then((snapshot) {
      setState(() {
        FireUserInfoEntity userInfo =
            fireUserInfoEntityFromJson(FireUserInfoEntity(), snapshot.data);
        userInfo.uid = snapshot.documentID;
        creater = userInfo;
      });
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getCommentList();
      }
    });
    _getCommentList();
  }

  @override
  void dispose() {
    creater = null;
    dataList.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 1080,
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemBuilder: _renderRow,
          itemCount:
              dataList.length == 0 ? 1 : dataList.length + (isEnd ? 1 : 2),
          controller: _scrollController,
        ),
      ),
    );
  }

  _sendComment() {
    if (!isSend && _formKey.currentState.validate()) {
      print('!!! _sendComment');
      setState(() => isSend = true);
//        isSend = true;
      FireStoreUtils.addComment(
              widget.squareReference.path, commentController.text)
          .then((doc) {
        setState(() {
          commentController.text = '';
          isSend = false;
          widget.square.comment += 1;
        });
        widget.squareReference.updateData({'comment': FieldValue.increment(1)});
        _refreshData();
      });
    }
  }

  Future<Null> _refreshData() async {
    dataList.clear();
    isLoading = false;
    isEnd = false;
    _getCommentList();
  }

  Future _getCommentList() async {
    if (isLoading) return;
    isLoading = true;

    var query = await FireStoreUtils.getCommentsByPath(
        widget.squareReference.path, dataList.length > 0 ? dataList.last : null,
        itemCount: commentStep);
    List<DocumentSnapshot> list = query.documents;
    print('!!! documents size ${list.length}');
    setState(() {
      isLoading = false;
      if (list.length < commentStep) {
        isEnd = true;
      }
      dataList.addAll(list);
    });
  }

  Widget getTop() {
    return Container(
        child: Column(
      children: <Widget>[
        CardBottomIcon(widget.square, widget.squareReference),
        Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                  backgroundImage: Config.user.photoUrl == null
                      ? AssetImage('assets/images/account_box.png')
                      : CloudImageProvider(Config.user.photoUrl)),
            ),
            Expanded(
              flex: 1,
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: commentController,
                  validator: (string) {
                    if (string.isEmpty) return 'commnet can\'t be empty.';
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Enter your commnet',
                      hintText: 'Just input any you want say.'),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.centerRight,
          child: RaisedButton(
            color: Colors.blue[400],
            child: Container(
              child: Text(isSend ? 'sending...' : 'send'),
            ),
            onPressed: () => _sendComment(),
          ),
        ),
      ],
    ));
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index == 0) {
      return getTop();
    }

    if (index < dataList.length + 1) {
      return buildItem(context: context, index: index - 1);
    }
    return BottomMore.getMoreWidget(isEnd);
  }

  Widget buildItem({BuildContext context, int index}) {
    DocumentSnapshot snapshot = dataList[index];
    CommentEntity entity =
        commentEntityFromJson(CommentEntity(), snapshot.data);
    entity.id = snapshot.documentID;
//    FireStoreUtils.queryUserinfo(entity.userID);
    var avatar = AvatarWidget(entity.userID);
    avatar.addClick(() => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserDetailsPage(avatar.userInforEntity))));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              avatar,
              Text(
                '${DateUtil.formatDate(DateTime.fromMillisecondsSinceEpoch(entity.time))}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 45),
              child: Text(
                entity.content,
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
