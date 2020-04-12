import 'package:car_repair/base/FirestoreUtils.dart';
import 'package:car_repair/entity/Square.dart';
import 'package:car_repair/publish/SquareDetails.dart';
import 'package:car_repair/utils/MonthUtil.dart';
import 'package:car_repair/widget/BottomMore.dart';
import 'package:car_repair/home/SquareCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SquarePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _SquareState();
  }
}

class _SquareState extends State<SquarePage> {
  Stream<QuerySnapshot> dataSteam;
  ScrollController _scrollController = ScrollController();
  String date;
  List<DocumentSnapshot> moreData = List();

  bool isEnd = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getData();
      }
    });
    date = MonthUtil.getCurrentData();
    dataSteam = FireStoreUtils.querySquareByType();
  }

  @override
  void dispose() {
    date = null;
    moreData.clear();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dataSteam,
//      stream: FireStoreUtils.querySquareByUser('${Config.user.uid}', 'default'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return LinearProgressIndicator();
        if (snapshot.connectionState == ConnectionState.none)
          return Center(
              child: Text(
            'No data!',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ));
        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        itemCount: snapshot.length,
        itemBuilder: (context, i) {
          if (i > snapshot.length || snapshot.length == 0) return null;
          if (i == snapshot.length) return BottomMore.getMoreWidget(isEnd);
          return _buildListItem(context, snapshot[i]);
        });
  }

  Widget _buildListMore(BuildContext context, List<DocumentSnapshot> snapshot) {
    if (snapshot.length == 0) _getData();
    snapshot.addAll(moreData);
    return RefreshIndicator(
        onRefresh: _onRefersh,
        child: ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.length == 0 ? 0 : snapshot.length + 1,
            itemBuilder: (context, i) {
              if (i > snapshot.length || snapshot.length == 0) return null;
              if (i == snapshot.length) return BottomMore.getMoreWidget(isEnd);
              return _buildListItem(context, snapshot[i]);
            }));
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final square = Square.fromJson(data.data);
    square.id = data.documentID;

    return Padding(
      key: ValueKey(square.id),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: SquareCard(square, (square) {
        square.click += 1;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SquareDetails(square, data.reference)));
        data.reference.updateData({'click': FieldValue.increment(1)});
      }),
    );
  }

  Future<Null> _onRefersh() async {
    moreData.clear();
    date = null;
    dataSteam = null;
    isEnd = false;
    _getData();
  }

  Future _getData() async {
    if (isLoading || isEnd) return;
    if (date == null) {
      setState(() {
        dataSteam = FireStoreUtils.querySquareByType();
      });
    } else {
      isLoading = true;
      FireStoreUtils.querySquareByTypeMore().then((value) {
        setState(() {
          if (value.length == 0) isEnd = true;
          moreData.addAll(value);
          isLoading = false;
        });
      });
    }

    print('!!! 加载数据.$date');
  }
}
